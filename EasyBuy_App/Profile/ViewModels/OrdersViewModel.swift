//
//  OrdersViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.10.2024.
//

import SwiftUI
import Combine

@MainActor
final class OrdersViewModel: ObservableObject {
    // MARK: - Properties
    @Published var orders = [Order]()
    @Published var statuses: [StatusOrderEnum]
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
    init(statuses: [StatusOrderEnum]) {
        self.statuses = statuses
        
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.fetchOrders()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Favorites
    func startOrders() async {
        await fetchOrders()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    private func fetchOrders() async {
        do {
            var orders = [Order]()
            for status in statuses {
                guard let url = URL(string: Constant.startURL(.orders) + (status == .all ? "" : "statusOrder/\(status.rawValue)")) else {
                    throw HttpError.badURL
                }
                
                #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
                if KeychainHelper.save(token: "4ax1JPZFQZSyG1VRTTpUbw==") {
                    print("Test Token added")
                } else  {
                    print("Test Token don't added")
                }
                #endif
                
                orders += try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            }
            withAnimation {
                self.orders = orders.sorted { $0.orderDate > $1.orderDate }
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
//            print("fetchOrders:", error)
        }
    }
}
