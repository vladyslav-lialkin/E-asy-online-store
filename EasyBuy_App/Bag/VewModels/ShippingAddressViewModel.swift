//
//  ShippingAddressViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 06.11.2024.
//

import Foundation
import SwiftUICore

@MainActor
final class ShippingAddressViewModel: BaseViewModel {
    // MARK: - Property
    @Published var user: User!
    @Published var name = ""
    @Published var lastname = ""
    @Published var phoneNumber = ""
    @Published var address = ""
    @Published var city = ""
    @Published var country = ""
    @Published var postalcode = ""
    @Published var isSuccess = false
    
    // MARK: - Shipping Address
    override func reloadData() async {
        await fetchUserInfo()
        isLoading = false
    }
        
    // MARK: - Fetch Methods
    private func fetchUserInfo() async {
        do {
            guard let url = URL(string: Constant.startURL(.users, .profile)) else {
                throw HttpError.badURL
            }
            
            let user: User = try await fetchData(from: url)
            
            self.user = user
            name = user.name ?? ""
            lastname = user.lastname ?? ""
            phoneNumber = user.phoneNumber ?? ""
            address = user.address ?? ""
            city = user.city ?? ""
            country = user.country ?? ""
            postalcode = user.postalcode ?? ""
        } catch {
            print("Error fetchUserInfo")
        }
    }
        
    // MARK: - Send Methods
    func updateUserAddress() {
        Task {
            do {
                guard let url = URL(string: Constant.startURL(.users, .profile, .update)) else {
                    throw HttpError.badURL
                }
                
                let updateUserDTO = UpdateUserDTO(name: name.isEmpty ? user.name : name,
                                                  lastname: lastname.isEmpty ? user.lastname : lastname,
                                                  city: city.isEmpty ? user.city : city,
                                                  address: address.isEmpty ? user.address : address,
                                                  phoneNumber: phoneNumber.isEmpty ? user.phoneNumber : phoneNumber,
                                                  country: country.isEmpty ? user.country : country,
                                                  postalcode: postalcode.isEmpty ? user.postalcode : postalcode)
                
                try await HttpClient.shared.sendData(to: url, object: updateUserDTO, httpMethod: .PATCH, token: KeychainHelper.getToken())
                
                withAnimation {
                    self.isSuccess = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isSuccess = false
                    }
                }
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            } catch {
                print("updateUserAddress:", error)
            }
        }
    }
}
