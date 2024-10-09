//
//  FavoritesViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 13.09.2024.
//

import Foundation
import SwiftUICore

@MainActor
final class FavoritesViewModel: BaseViewModel {
    // MARK: - Property
    @Published var favorites = [Favorite]()
    
    // MARK: - Start Favorites
    override func reloadData() async {
        await fetchFavorites()
        isLoading = false
    }
        
    // MARK: - Fetch Methods
    private func fetchFavorites() async {
        do {
            guard let url = URL(string: Constant.startURL(.favorites)) else {
                throw HttpError.badURL
            }
                                
            let favorites: [Favorite] = try await fetchData(from: url)
            
            withAnimation {
                self.favorites = favorites.sorted(by: { $0.createdDate > $1.createdDate })
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchFavorites:", error)
        }
    }
        
    // MARK: - Delete Methods
    func deleteFavorite(for id: UUID) {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.favorites) + id.uuidString) else {
                    throw HttpError.badURL
                }
                                
                try await HttpClient.shared.delete(url: url, token: KeychainHelper.getToken())
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            }
            
            await fetchFavorites()
        }
    }
}
