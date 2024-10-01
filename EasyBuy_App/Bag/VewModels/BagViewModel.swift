//
//  BagViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.09.2024.
//

import SwiftUI
import Combine

import MapKit

@MainActor
final class BagViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var bags = [Bag]()
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
                Task {
                    await self?.startBags()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Favorites
    func startBags() async {
        await fetchBags()        
        isLoading = false
    }
        
    // MARK: - Fetch Methods
    private func fetchBags() async {
        do {
            guard let url = URL(string: Constant.startURL(.cartitems)) else {
                throw HttpError.badURL
            }
            
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            if KeychainHelper.save(token: "4ax1JPZFQZSyG1VRTTpUbw==") {
                print("Test Token added")
            } else  {
                print("Test Token don't added")
            }
            #endif
                                
            let bags: [Bag] = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
            withAnimation {
                self.bags = bags.sorted { $0.createdDate > $1.createdDate }
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
            print("fetchFavorites:", error)
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
            
            if var storedValues = UserDefaults.standard.stringArray(forKey: "selected") {
                storedValues.removeAll(where: { $0 == id.uuidString })
                UserDefaults.standard.set(storedValues, forKey: "selected")
            }
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
