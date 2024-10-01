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
    init() {
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isLoading = true
                Task {
                    await self.startFavorites()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Favorites
    func startFavorites() async {
        await fetchFavorites()
        isLoading = false
    }
        
    // MARK: - Fetch Methods
    private func fetchFavorites() async {
        do {
            guard let url = URL(string: Constant.startURL(.favorites)) else {
                throw HttpError.badURL
            }
            
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            if KeychainHelper.save(token: "4ax1JPZFQZSyG1VRTTpUbw==") {
                print("Test Token added")
            } else  {
                print("Test Token don't added")
            }
            #endif
                                
            let favorites: [Favorite] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
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
            
            await startFavorites()
        }
    }
}
