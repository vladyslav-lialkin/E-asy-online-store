//
//  OrderDetailsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import SwiftUI
import Combine

@MainActor
final class OrderDetailsViewModel: ObservableObject {
    // MARK: - Properties
    @Published var order: Order!
    @Published var orderID: UUID
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
    init(id: UUID) {
        orderID = id
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.fetchOrder()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Favorites
    func startOrder() async {
        await fetchOrder()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    private func fetchOrder() async {
        do {
            guard let url = URL(string: Constant.startURL(.orders) + orderID.uuidString) else {
                throw HttpError.badURL
            }
            
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            if KeychainHelper.save(token: "4ax1JPZFQZSyG1VRTTpUbw==") {
                print("Test Token added")
            } else  {
                print("Test Token don't added")
            }
            #endif
            
            order = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
//            print("fetchOrder:", error)
        }
    }
}
