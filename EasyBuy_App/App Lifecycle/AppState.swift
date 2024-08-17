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
        if KeychainHelper.getToken() != nil {
            isAuthenticated = true
            
            onSuccess?()
        } else {
            isAuthenticated = false
        }
    }
}
