//
//  ProfileViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 02.10.2024.
//

import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Property
    @Published var user: User!
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
    
    let emojis = [
        "😀", "😅", "🤣", "😊", "😍", "😎", "🤓", "😜", "🥳", "🤩",
        "😇", "🤯", "😱", "🥺", "🙈", "🙉", "🙊", "😷", "🤠", "👽",
        "🤖", "👾", "🦄", "🐶", "🐱", "🐵", "🐸", "🐼", "🐻", "🦊",
        "🌟", "⚡️", "🔥", "💧", "🌈", "💫", "🎃", "🎄", "🎉", "❤️"
    ]
        
    // MARK: - Init
    init() {
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.startUser()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Favorites
    func startUser() async {
        await fetchUser()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    private func fetchUser() async {
        do {
            guard let url = URL(string: Constant.startURL(.users, .profile)) else {
                throw HttpError.badURL
            }
            
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            if KeychainHelper.save(token: "4ax1JPZFQZSyG1VRTTpUbw==") {
                print("Test Token added")
            } else  {
                print("Test Token don't added")
            }
            #endif
                                
            let user: User = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
            withAnimation {
                self.user = user
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchFavorites:", error)
        }
    }
}
