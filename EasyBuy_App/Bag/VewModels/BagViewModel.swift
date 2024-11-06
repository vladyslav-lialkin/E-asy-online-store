//
//  BagViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.09.2024.
//

import Foundation
import SwiftUICore

@MainActor
final class BagViewModel: BaseViewModel {
    // MARK: - Property
    @Published var bags = [Bag]()
    
    // MARK: - Start Bag
    override func reloadData() async {
        await fetchBags()
        isLoading = false
    }
        
    // MARK: - Fetch Methods
    private func fetchBags() async {
        do {
            guard let url = URL(string: Constant.startURL(.cartitems)) else {
                throw HttpError.badURL
            }
                                            
            let bags: [Bag] = try await fetchData(from: url)
            
            withAnimation {
                self.bags = bags.sorted { $0.createdDate > $1.createdDate }
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchBags:", error)
        }
    }
        
    // MARK: - Send Methods
    func updateBag(for bag: Bag, _ update: UpdateBag) async {
        do {
            guard let url = URL(string: Constant.startURL(.cartitems) + bag.id.uuidString) else {
                throw HttpError.badURL
            }
            
            let quantity: Int? = {
                switch update {
                case .addQuantity:
                    return bag.quantity + 1
                case .subtractQuantity:
                    return bag.quantity - 1
                case .isSelected:
                    return nil
                }
            }()
            
            let isSelected: Bool? = {
                switch update {
                case .isSelected:
                    return !bag.isSelected
                case .addQuantity, .subtractQuantity:
                    return nil
                }
            }()
            
            guard quantity ?? 1 >= 1 else {
                await deleteBag(for: bag.id)
                return
            }
            
            let updateBagDTO = UpdateBagDTO(quantity: quantity, isSelected: isSelected)
                            
            try await HttpClient.shared.sendData(to: url, object: updateBagDTO, httpMethod: .PATCH, token: KeychainHelper.getToken())
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("updateBag:", error)
        }
    }
    
    func updateAllSelected() {
        let value = bags.allSatisfy(\.isSelected)
        
        Task {
            for bag in bags {
                if bag.isSelected == value {
                    await updateBag(for: bag, .isSelected)
                }
            }
            
            await fetchBags()
        }
    }
    
    func buyAllSelected() {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.orders)) else {
                    throw HttpError.badURL
                }
                
                var createOrderDTOs = [CreateOrderDTO]()
                
                for bag in bags.filter({ $0.isSelected }) {
                    createOrderDTOs.append(
                        CreateOrderDTO(productID: bag.productID,
                                       quantity: bag.quantity)
                    )
                }
                
                try await HttpClient.shared.sendData(to: url,
                                                     object: createOrderDTOs,
                                                     httpMethod: .POST,
                                                     token: KeychainHelper.getToken())

                deleteAllSelected()
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            } catch {
                print("buyAllSelected:", error)
            }
            await fetchBags()
        }
    }
    
    // MARK: - Delete Methods
    func deleteBag(for id: UUID) async {
        do {
            guard let url = URL(string: Constant.startURL(.cartitems) + id.uuidString) else {
                throw HttpError.badURL
            }
                            
            try await HttpClient.shared.delete(url: url, token: KeychainHelper.getToken())
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("deleteBag:", error)
        }
    }
    
    func deleteAllSelected() {
        Task {
            for bag in bags.filter({ $0.isSelected }) {
                await deleteBag(for: bag.id)
            }
            
            await fetchBags()
        }
    }
}
