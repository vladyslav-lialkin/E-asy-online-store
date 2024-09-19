//
//  AppState.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 12.08.2024.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    init() {
        checkAuthentication()
    }
    
    func checkAuthentication(onSuccess: (() -> Void)? = nil) {
        do {
            let token = try KeychainHelper.getToken()
            
            guard !token.isEmpty else {
                throw HttpError.badToken
            }
            
            isAuthenticated = true
            onSuccess?()
        } catch {
            print(error)
            isAuthenticated = false
        }
    }
}
