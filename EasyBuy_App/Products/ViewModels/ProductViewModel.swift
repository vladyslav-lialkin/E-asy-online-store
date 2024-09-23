//
//  ProductViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import SwiftUI
import Combine

class ProductViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var product: Product?
    @Published var productID: UUID
    
    @Published var favorite: Favorite?
    @Published var reviews = [Review]()
    @Published var review = ""
    @Published var rating = 0
    
    @Published var errorMessage: LocalizedStringKey? {
        didSet {
            if errorMessage != nil {
                sleep(10)
                withAnimation {
                    errorMessage = nil
                }
            }
        }
    }
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(productID: UUID) {
        self.productID = productID
        startProduct()
        
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                self?.startProduct()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Product
    func startProduct() {
        fetchProduct()
        fetchFavorite()
        fetchReview()
    }
    
    // MARK: - Error Handling Methods
    func updateError(_ error: LocalizedStringKey?) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = error
            self?.isLoading = false
        }
    }
    
    // MARK: - Fetch Methods
    func fetchProduct() {
        isLoading = true
        Task {
            do {
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.products.rawValue + "/" + productID.uuidString) else {
                    throw HttpError.badURL
                }
                
                #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
                if KeychainHelper.save(token: "awHBfIFzYT51CpzgEzbWDg==") {
                    print("Test Token added")
                } else  {
                    print("Test Token don't added")
                }
                #endif
                        
                let product: Product = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
                
                DispatchQueue.main.async { [weak self] in
                    self?.product = product
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
        }
    }
    
    func fetchFavorite() {
        Task {
            do {
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.favorites.rawValue) else {
                    throw HttpError.badURL
                }
                        
                let favorites: [Favorite] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
                
                DispatchQueue.main.async { [weak self] in
                    self?.favorite = (favorites.first(where: { favorite in
                        favorite.productID == self?.productID
                    }))
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
    
    func fetchReview() {
        Task {
            do {
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.reviews.rawValue + "/" + productID.uuidString) else {
                    throw HttpError.badURL
                }
                                        
                let reviews: [Review] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
                
                DispatchQueue.main.async { [weak self] in
                    self?.reviews = reviews
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
    
    
    // MARK: - SendData Methods
    func addToFavorite() {
        Task {
            do {
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.favorites.rawValue) else {
                    throw HttpError.badURL
                }

                let createFavoriteDTO = CreateFavoriteDTO(productID: productID)
                
                try await HttpClient.shared.sendData(to: url, object: createFavoriteDTO, httpMethod: .POST, token: KeychainHelper.getToken())
                
                fetchFavorite()
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
    
    func addToBag() {
        Task {
            do {
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.cartitems.rawValue) else {
                    throw HttpError.badURL
                }
                                        
                let createBagDTO = CreateBagDTO(productID: productID, quantity: 1)
                
                try await HttpClient.shared.sendData(to: url, object: createBagDTO, httpMethod: .POST, token: KeychainHelper.getToken())
                
                DispatchQueue.main.async { [weak self] in
                    self?.review = ""
                    self?.rating = 0
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
    
    func addReview() {
        Task {
            do {
                guard !review.isEmpty, rating > 0 else {
                    return
                }
                
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.reviews.rawValue) else {
                    throw HttpError.badURL
                }
                        
                let createReviewDTO = CreateReviewDTO(productID: productID, rating: rating, comment: review)
                
                try await HttpClient.shared.sendData(to: url, object: createReviewDTO, httpMethod: .POST, token: KeychainHelper.getToken())
                
                DispatchQueue.main.async { [weak self] in
                    self?.review = ""
                    self?.rating = 0
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
    
    
    // MARK: - Delete Methods
    func deleteFavorite() {
        Task {
            do {
                guard let favorite = favorite else {
                    throw HttpError.propertyDoesntExist
                }
                
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.favorites.rawValue + "/" + favorite.id.uuidString) else {
                    throw HttpError.badURL
                }
                                
                try await HttpClient.shared.delete(url: url, token: KeychainHelper.getToken())
                
                DispatchQueue.main.async { [weak self] in
                    self?.favorite = nil
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
}
