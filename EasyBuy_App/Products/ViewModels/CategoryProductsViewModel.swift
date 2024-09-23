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
                
                let products: [Product] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
                                
                DispatchQueue.main.async { [weak self] in
                    self?.products = products.sorted(by: { $0.createdAt > $1.createdAt })
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

