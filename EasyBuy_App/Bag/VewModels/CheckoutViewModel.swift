//
//  CheckoutViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.11.2024.
//

import Foundation
import SwiftUICore
import Stripe

@MainActor
final class CheckoutViewModel: BaseViewModel {
    // MARK: - Property
    @Published var user: User!
    @Published var selectedBags = [Bag]()
    @Published var promoCode = ""
    @Published var isEmptyAddress = true
    @Published var successPayment: Bool = false
    @Published var paymentIntentParams: STPPaymentIntentParams?
    @Published var isEnterCardDeteil: Bool!
    
    // Computed properties
    var totalPrice: Double {
        selectedBags.reduce(0.00) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    // MARK: - Init
    override init() {
        super.init()
        fetchSelectedBags()
    }
    
    // MARK: - Start Checkout
    override func reloadData() async {
        await fetchUserInfo()
        preparePaymentIntent()
    }
    
    // MARK: - Validation Methods
    func isPaymentMethodComplete(paymentMethodParams: STPPaymentMethodParams?) -> Bool {
        guard let card = paymentMethodParams?.card else {
            withAnimation {
                isEnterCardDeteil = false
            }
            return false
        }

        if card.number == nil || card.expMonth == nil || card.expYear == nil || card.cvc == nil {
            withAnimation {
                isEnterCardDeteil = false
            }
            return false
        }
        withAnimation {
            isEnterCardDeteil = true
        }
        return true
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
    
    private func fetchUserInfo() async {
        do {
            guard let url = URL(string: Constant.startURL(.users, .profile)) else {
                throw HttpError.badURL
            }
            
            let user: User = try await fetchData(from: url)
            
            if [user.name, user.lastname, user.phoneNumber, user.address, user.city, user.country, user.postalcode].allSatisfy({ $0 != nil }) {
                self.user = user
                isEmptyAddress = false
            }
        } catch {
            print("Error fetchUserInfo")
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
        
        paymentIntentParams = nil
        preparePaymentIntent()
    }
    
    func preparePaymentIntent() {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.products, .createPaymentIntent)) else {
                    throw HttpError.badURL
                }
                
                let paymentIntentRequest = PaymentIntentRequest(
                    amount: Int(totalPrice * 100)
                )
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("Bearer \(try KeychainHelper.getToken())",
                                 forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONEncoder().encode(paymentIntentRequest)
                
                let (data, _) = try await URLSession.shared.data(for: request)
                                
                guard let clientSecret = try? JSONDecoder().decode(PaymentIntentResponse.self, from: data).clientSecret else {
                    print("Failed to decode response from server.")
                    return preparePaymentIntent()
                }
                
                STPAPIClient.shared.publishableKey = "pk_test_51QIU4kKPGGHHFsHCG57tOUojmsmYq5kEGQQnaJIpk16DvV38Hlv6gEmotbCwtutAtdrtgxa0sEIM9YfqYRwXdnr100ubKELx4u"
                paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            } catch {
                print("preparePaymentIntent:", error)
            }
        }
    }
    
    func onCompletion(status: STPPaymentHandlerActionStatus, paymentIntent: STPPaymentIntent?, error: Error?, onSuccess: @escaping (() -> Void)) {
        if let paymentIntent {
            print("paymentIntent:", paymentIntent)
        }
        if let error {
            print("error:", error)
        }
        
        switch status {
        case .succeeded:
            withAnimation {
                successPayment = true
            }
            buyAllSelected {
                onSuccess()
            }
        case .canceled:
            errorMessage = "Payment canceled"
        case .failed:
            errorMessage = "Payment failed"
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    onSuccess()
                }
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
        paymentIntentParams = nil
        preparePaymentIntent()
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
