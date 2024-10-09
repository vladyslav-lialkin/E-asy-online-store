//
//  OrdersViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.10.2024.
//

import SwiftUI

@MainActor
final class OrdersViewModel: BaseViewModel {
    // MARK: - Properties
    @Published var orders = [Order]()
    @Published var statuses: [StatusOrderEnum]

    // MARK: - Init
    init(statuses: [StatusOrderEnum]) {
        self.statuses = statuses
        super.init()
    }
    
    // MARK: - Start Orders
    override func reloadData() async {
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
                
                orders += try await fetchData(from: url)
            }
            withAnimation {
                self.orders = orders.sorted { $0.orderDate > $1.orderDate }
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchOrders:", error)
        }
    }
}
