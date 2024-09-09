//
//  ProductViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import SwiftUI

class ProductViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var product: Product?
    @Published var favorite: Favorite?
    @Published var productID: UUID
    
    
    @Published var errorMessage: LocalizedStringKey? {
        didSet {
            if errorMessage != nil {
                startErrorTimeout()
            }
        }
    }
    @Published var isLoading = false
    
    // MARK: - Init
    init(productID: UUID) {
        self.productID = productID
        fetchProduct()
        fetchFavorite()
    }
    
    // MARK: - Error Handling Methods
    func updateError(_ error: LocalizedStringKey?) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = error
            self?.isLoading = false
        }
    }
    
    private func startErrorTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            withAnimation {
                self?.errorMessage = nil
            }
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
                        
                guard let token = KeychainHelper.getToken() else {
                    throw HttpError.badToken
                }
                
                let product: Product = try await HttpClient.shared.fetch(url: url, token: token)
                
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
                        
                guard let token = KeychainHelper.getToken() else {
                    throw HttpError.badToken
                }
                
                let favorites: [Favorite] = try await HttpClient.shared.fetch(url: url, token: token)
                
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
    
    func addToFavorite() {
        Task {
            do {
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.favorites.rawValue) else {
                    throw HttpError.badURL
                }

                guard let token = KeychainHelper.getToken() else {
                    throw HttpError.badToken
                }
                
                let createFavoriteDTO = CreateFavoriteDTO(productID: productID)
                
                try await HttpClient.shared.sendData(to: url, object: createFavoriteDTO, httpMethod: .POST, token: token)
                
                fetchFavorite()
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
    
    func deleteFavorite() {
        Task {
            do {
                guard let favorite = favorite else {
                    throw HttpError.propertyDoesntExist
                }
                
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.favorites.rawValue + "/" + favorite.id.uuidString) else {
                    throw HttpError.badURL
                }
                        
                guard let token = KeychainHelper.getToken() else {
                    throw HttpError.badToken
                }
                                
                try await HttpClient.shared.delete(url: url, token: token)
                
                DispatchQueue.main.async { [weak self] in
                    self?.favorite = nil
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
}
