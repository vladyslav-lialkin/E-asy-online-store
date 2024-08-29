//
//  CategoryProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI

class CategoryProductsViewModel: ObservableObject {
    
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
    
    @Published var searchText = ""
    @Published var category: CategoryEnum.RawValue
    
    // MARK: - Init
    init(category: CategoryEnum.RawValue) {
        self.category = category
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
        guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.products.rawValue + "/category/" + category) else {
            throw HttpError.badURL
        }
        
//        if KeychainHelper.save(token: "PGA0P0n6IjfnggNQJ0KdZw==") {
//            print("Test Token added")
//        } else  {
//            print("Test Token don't added")
//        }
        
        guard let token = KeychainHelper.getToken() else {
            throw HttpError.badToken
        }
        
        let products: [Product] = try await HttpClient.shared.fetch(url: url, token: token)
        
        return products
    }
}

