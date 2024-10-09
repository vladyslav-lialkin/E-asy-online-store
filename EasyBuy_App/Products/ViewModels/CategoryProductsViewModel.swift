//
//  CategoryProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import Foundation

@MainActor
final class CategoryProductsViewModel: BaseViewModel {
    // MARK: - Property
    @Published var products = [Product]()
    @Published var category: CategoryEnum.RawValue
        
    // MARK: - Init
    init(category: CategoryEnum.RawValue) {
        self.category = category
        super.init()
    }
    
    // MARK: - Start Category Products
    override func reloadData() async {
        await fetchProducts()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    func fetchProducts() async {
        do {
            guard let url = URL(string: Constant.startURL(.products, .category) + category) else {
                throw HttpError.badURL
            }
            
            let products: [Product] = try await fetchData(from: url)
            self.products = products.sorted(by: { $0.createdAt > $1.createdAt })
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchProducts", error)
        }
    }
}

