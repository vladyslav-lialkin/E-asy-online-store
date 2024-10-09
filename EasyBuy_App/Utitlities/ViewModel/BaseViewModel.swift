//
//  BaseViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 09.10.2024.
//

import SwiftUI
import Combine

@MainActor
class BaseViewModel: ObservableObject {
    // MARK: - Properties
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
        subscribeToNotification()
    }

    private func subscribeToNotification() {
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.reloadData()
                }
            }
            .store(in: &cancellables)
    }

    func reloadData() async {
        
    }
    
    func fetchData<T: Codable>(from url: URL) async throws -> T {
        return try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
    }
}
