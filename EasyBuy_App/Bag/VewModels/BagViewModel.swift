//
//  BagViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.09.2024.
//

import SwiftUI
import Combine

@MainActor
final class BagViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var bags = [Bag]()
    @Published var products = [Product]()
    
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
    init() {
        isLoading = true
        Task {
            NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
                .sink { [weak self] _ in
                    Task {
                        await self?.startBags()
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - Start Favorites
    func startBags() async {
        await fetchBags()
        await fetchProducts()
        
        isLoading = false
    }
        
    // MARK: - Fetch Methods
    private func fetchBags() async {
        do {
            guard let url = URL(string: Constant.startURL(.cartitems)) else {
                throw HttpError.badURL
            }
            
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            if KeychainHelper.save(token: "awHBfIFzYT51CpzgEzbWDg==") {
                print("Test Token added")
            } else  {
                print("Test Token don't added")
            }
            #endif
                                
            let bags: [Bag] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
            self.bags = bags.sorted(by: { $0.createdDate > $1.createdDate })
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchFavorites:", error)
        }
    }

    private func fetchProducts() async {
        var fetchedProducts = [Product]()
        
        for bag in bags {
            do {
                guard let url = URL(string: Constant.startURL(.products) + "/" + bag.productID.uuidString) else {
                    print("Invalid URL for productID:", bag.productID.uuidString)
                    throw HttpError.badToken
                }
                
                let product: Product = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
                
                fetchedProducts.append(product)
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            } catch {
                print("fetchProducts error:", error)
            }
        }
        
        self.products = fetchedProducts
    }
        
    // MARK: - Delete Methods
    func deleteBag(for id: UUID) {
        Task {
            do {
                guard let bag = bags.first(where: { $0.productID == id}) else {
                    throw HttpError.propertyDoesntExist
                }
                
                guard let url = URL(string: Constant.startURL(.favorites) + bag.id.uuidString) else {
                    throw HttpError.badURL
                }
                                
                try await HttpClient.shared.delete(url: url, token: KeychainHelper.getToken())
                
                bags.removeAll(where: { $0.productID == id})
                products.removeAll(where: { $0.id == id})
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            }
            
            await startBags()
        }
    }
}
