//
//  PersonalDataViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import SwiftUI
import Combine

@MainActor
final class PersonalDataViewModel: ObservableObject {
    // MARK: - Property
    @Published var user: User!
    @Published var isEmojiPicker = false
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
    
    @AppStorage("emoji") var emoji = String()
    
    private var cancellables = Set<AnyCancellable>()
            
    // MARK: - Init
    init() {
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.fetchUserData()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Favorites
    func startUserData() async {
        await fetchUserData()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    func fetchUserData() async {
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
//            print("fetchUserData:", error)
        }
    }
}
