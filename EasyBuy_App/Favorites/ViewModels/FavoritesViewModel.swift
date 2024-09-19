//
//  FavoritesViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 13.09.2024.
//

import SwiftUI
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var favorites = [Favorite]()
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
//    private var debounceTask: Task<Void, Never>?
    
    // MARK: - Init
    init() {
        isLoading = true
        Task {
            NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
                .sink { [weak self] _ in
//                    guard let self = self else { return }
                    self?.isLoading = true
                    Task {
                        await self?.startFavorites()
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - Start Favorites
    func startFavorites() async {
        await fetchFavorites()
        await fetchProducts()
        
        isLoading = false    }
        
    // MARK: - Fetch Methods
    private func fetchFavorites() async {
        do {
            guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.favorites.rawValue) else {
                throw HttpError.badURL
            }
            
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            if KeychainHelper.save(token: "awHBfIFzYT51CpzgEzbWDg==") {
                print("Test Token added")
            } else  {
                print("Test Token don't added")
            }
            #endif
                                
            let favorites: [Favorite] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
            self.favorites = favorites.sorted(by: { $0.createdDate > $1.createdDate })
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchFavorites:", error)
        }
    }

    private func fetchProducts() async {
        let startURL = Constants.baseURL.rawValue + Endpoints.products.rawValue
        var fetchedProducts = [Product]()
        
        for favorite in favorites {
            do {
                guard let url = URL(string: startURL + "/" + favorite.productID.uuidString) else {
                    print("Invalid URL for productID:", favorite.productID.uuidString)
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
    func deleteFavorite(for id: UUID) {
        Task {
            do {
                guard let favorite = favorites.first(where: { $0.productID == id}) else {
                    throw HttpError.propertyDoesntExist
                }
                
                guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.favorites.rawValue + "/" + favorite.id.uuidString) else {
                    throw HttpError.badURL
                }
                                
                try await HttpClient.shared.delete(url: url, token: KeychainHelper.getToken())
                
                favorites.removeAll(where: { $0.productID == id})
                products.removeAll(where: { $0.id == id})
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            }
            
            await startFavorites()
        }
    }
}
