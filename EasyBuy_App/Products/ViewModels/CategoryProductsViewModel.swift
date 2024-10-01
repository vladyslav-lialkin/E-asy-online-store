//
//  CategoryProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI
import Combine

@MainActor
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
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(category: CategoryEnum.RawValue) {
        self.category = category
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.startCategoryProducts()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Category Products
    func startCategoryProducts() async {
        await fetchProducts()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    func fetchProducts() async {
        do {
            guard let url = URL(string: Constant.startURL(.products, .category) + category) else {
                throw HttpError.badURL
            }
            
            let products: [Product] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            self.products = products.sorted(by: { $0.createdAt > $1.createdAt })
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchProducts", error)
        }
    }
}

