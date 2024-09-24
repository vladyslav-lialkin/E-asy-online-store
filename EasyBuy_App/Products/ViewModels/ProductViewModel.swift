//
//  ProductViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import SwiftUI
import Combine

@MainActor
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                    withAnimation {
                        self?.errorMessage = nil
                    }
                }
            }
        }
    }
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(productID: UUID) {
        self.productID = productID
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.startProduct()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Product
    func startProduct() async {
        await fetchProduct()
        await fetchFavorite()
        await fetchReview()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    func fetchProduct() async {
        do {
            guard let url = URL(string: Constant.startURL(.products) + productID.uuidString) else {
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
            self.product = product
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchProduct", error)
        }
    }
    
    func fetchFavorite() async {
        do {
            guard let url = URL(string: Constant.startURL(.favorites)) else {
                throw HttpError.badURL
            }
                    
            let favorites: [Favorite] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
            self.favorite = (favorites.first(where: { favorite in
                favorite.productID == productID
            }))
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchFavorite", error)
        }
    }
    
    func fetchReview() async {
        do {
            guard let url = URL(string: Constant.startURL(.reviews) + productID.uuidString) else {
                throw HttpError.badURL
            }
                                    
            let reviews: [Review] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
            DispatchQueue.main.async { [weak self] in
                self?.reviews = reviews
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchReview", error)
        }
    }
    
    
    // MARK: - SendData Methods
    func addToFavorite() {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.favorites)) else {
                    throw HttpError.badURL
                }

                let createFavoriteDTO = CreateFavoriteDTO(productID: productID)
                
                try await HttpClient.shared.sendData(to: url, object: createFavoriteDTO, httpMethod: .POST, token: KeychainHelper.getToken())
                
                await fetchFavorite()
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            }
        }
    }
    
    func addToBag() {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.cartitems)) else {
                    throw HttpError.badURL
                }
                                        
                let createBagDTO = CreateBagDTO(productID: productID, quantity: 1)
                
                try await HttpClient.shared.sendData(to: url, object: createBagDTO, httpMethod: .POST, token: KeychainHelper.getToken())
                
                DispatchQueue.main.async { [weak self] in
                    self?.review = ""
                    self?.rating = 0
                }
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            }
        }
    }
    
    func addReview() {
        Task {
            do {
                guard !review.isEmpty, rating > 0 else {
                    return
                }
                
                guard let url = URL(string: Constant.startURL(.reviews)) else {
                    throw HttpError.badURL
                }
                        
                let createReviewDTO = CreateReviewDTO(productID: productID, rating: rating, comment: review)
                
                try await HttpClient.shared.sendData(to: url, object: createReviewDTO, httpMethod: .POST, token: KeychainHelper.getToken())
                
                review = ""; rating = 0
                await fetchReview()
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
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
                
                guard let url = URL(string: Constant.startURL(.favorites) + favorite.id.uuidString) else {
                    throw HttpError.badURL
                }
                                
                try await HttpClient.shared.delete(url: url, token: KeychainHelper.getToken())
                
                self.favorite = nil
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            }
        }
    }
}
