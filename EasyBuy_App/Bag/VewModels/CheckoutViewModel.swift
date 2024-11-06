//
//  CheckoutViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.11.2024.
//

import Foundation
import SwiftUICore

@MainActor
final class CheckoutViewModel: BaseViewModel {
    // MARK: - Property
    @Published var selectedBags = [Bag]()
    @Published var user: User!
    @Published var promoCode = ""
    @Published var errorPromoCode: String? = nil
    @Published var isEmptyAddress = true
    
    // MARK: - Start Checkout
    override init() {
        super.init()
        fetchSelectedBags()
        fetchUserInfo()
    }
        
    // MARK: - Fetch Methods
    private func fetchSelectedBags() {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.cartitems)) else {
                    throw HttpError.badURL
                }
                
                let bags: [Bag] = try await fetchData(from: url)
                
                withAnimation {
                    self.selectedBags = bags.filter({ $0.isSelected }).sorted { $0.createdDate > $1.createdDate }
                }
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            } catch {
                print("fetchSelectedBags:", error)
            }
            isLoading = false
        }
    }
    
    private func fetchUserInfo() {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.users, .profile)) else {
                    throw HttpError.badURL
                }
                
                let user: User = try await fetchData(from: url)
                
                if [user.name, user.lastname, user.phoneNumber, user.address, user.city, user.country, user.postalcode].allSatisfy({ $0 != nil }) {
                    self.user = user
                    isEmptyAddress = false
                }
            }
        }
    }
        
    // MARK: - Send Methods
    func updateBag(for bag: Binding<Bag>, _ update: UpdateBag) {
        bag.wrappedValue.quantity = {
            switch update {
            case .addQuantity:
                return bag.wrappedValue.quantity + 1
            case .subtractQuantity:
                return bag.wrappedValue.quantity - 1
            case .isSelected:
                return bag.wrappedValue.quantity
            }
        }()
        
        guard bag.wrappedValue.quantity >= 1 else {
            deleteBag(for: bag.wrappedValue.id)
            return
        }
    }
        
    func buyAllSelected(onSuccess: @escaping (() -> Void)) {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.orders)) else {
                    throw HttpError.badURL
                }
                
                var createOrderDTOs = [CreateOrderDTO]()
                
                for bag in selectedBags {
                    createOrderDTOs.append(
                        CreateOrderDTO(productID: bag.productID,
                                       quantity: bag.quantity)
                    )
                }
                
                try await HttpClient.shared.sendData(to: url,
                                                     object: createOrderDTOs,
                                                     httpMethod: .POST,
                                                     token: KeychainHelper.getToken())

                await deleteAllSelected()
                onSuccess()
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            } catch {
                print("buyAllSelected:", error)
            }
        }
    }
    
    // MARK: - Delete Methods
    func deleteBag(for id: UUID) {
        withAnimation {
            selectedBags.removeAll(where: { $0.id == id })
        }
    }
    
    func deleteAllSelected() async {
        for bag in selectedBags {
            do {
                guard let url = URL(string: Constant.startURL(.cartitems) + bag.id.uuidString) else {
                    throw HttpError.badURL
                }
                                
                try await HttpClient.shared.delete(url: url, token: KeychainHelper.getToken())
            } catch {
                print("deleteBag:", error)
            }
        }
    }
}
