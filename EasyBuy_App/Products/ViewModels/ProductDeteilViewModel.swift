//
//  ProductDeteilViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import SwiftUI

class ProductDeteilViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var imagesURL = [URL]()
    @Published var title = ""
    @Published var price = ""
    
    @Published var favorite = false
    
    
    
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
                if KeychainHelper.save(token: "PGA0P0n6IjfnggNQJ0KdZw==") {
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
                    self?.imagesURL = product.imagesUrl
                    self?.title = product.name
                    self?.price = String(format: "%.2f", product.price)
                    self?.isLoading = false
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
    
    func fetchFavorite() {
        isLoading = true
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
                    }) != nil)
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
        }
    }
}
