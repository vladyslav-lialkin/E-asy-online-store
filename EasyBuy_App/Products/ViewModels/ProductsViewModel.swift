//
//  ProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI


class ProductsViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var products = [Product]()
    
    @Published var errorMessage: LocalizedStringKey? {
        didSet {
            if errorMessage != nil {
                startErrorTimeout()
            }
        }
    }
    
    @Published var isLoading = false
    
    let categories = ["iPhone", "Apple\nWatch", "iPad", "Mac", "Apple\nVision Pro", "AirPods", "Apple TV 4K", "HomePod", "AirTag"]
    let categoriesImage = ["iPhone", "Apple Watch", "iPad", "Mac", "Apple Vision Pro", "AirPods", "Apple TV 4K", "HomePod", "AirTag"]
    
    
    // MARK: - Init
    init() {
        isLoading = true
        Task {
            do {
                let products = try await fetchProducts()
                
                DispatchQueue.main.async { [weak self] in
                    self?.products = products
                }
            } catch let error as HttpError {
                updateError(HandlerError.httpError(error))
            }
            isLoading(false)
        }
    }
    
    // MARK: - Update isLoading
    func isLoading(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = bool
        }
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
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.products.rawValue) else {
            throw HttpError.badURL
        }
        
        guard let token = KeychainHelper.getToken() else {
            throw HttpError.badToken
        }
        
        var products: [Product] = try await HttpClient.shared.fetch(url: url, token: token)
        
        for index in 0..<products.count {
            if let url = products[index].imagesUrl.first {
                products[index].imagesData += [try await HttpClient.shared.fetch(url: url)]
            }
        }

        return products
    }
}
