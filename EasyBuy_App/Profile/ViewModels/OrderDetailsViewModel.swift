//
//  OrderDetailsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import Foundation

@MainActor
final class OrderDetailsViewModel: BaseViewModel {
    // MARK: - Properties
    @Published var order: Order!
    @Published var orderID: UUID
        
    // MARK: - Init
    init(id: UUID) {
        orderID = id
        super.init()
    }
    
    // MARK: - Start OrderDetails
    override func reloadData() async {
        await fetchOrder()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    private func fetchOrder() async {
        do {
            guard let url = URL(string: Constant.startURL(.orders) + orderID.uuidString) else {
                throw HttpError.badURL
            }
            
            order = try await fetchData(from: url)
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchOrder:", error)
        }
    }
}
