//
//  CategoryProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI
import Combine

class CategoryProductsViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var products = [Product]()
    @Published var category: CategoryEnum.RawValue
    
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
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(category: CategoryEnum.RawValue) {
        self.category = category
        startCategoryProducts()
        
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                self?.startCategoryProducts()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Category Products
    func startCategoryProducts() {
        fetchProducts()
    }
    
    // MARK: - Fetch Methods
    func fetchProducts() {
        isLoading = true
        Task {
            do {
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.products.rawValue + "/category/" + category) else {
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
                
                let products: [Product] = try await HttpClient.shared.fetch(url: url, token: token)
                                
                DispatchQueue.main.async { [weak self] in
                    self?.products = products
                    self?.isLoading = false
                }
            } catch let error as HttpError {
                DispatchQueue.main.async { [weak self] in
                    self?.errorMessage = HandlerError.httpError(error)
                    self?.isLoading = false
                }
            }
        }
    }
}

