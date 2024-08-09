//
//  SignUpLogInCoordinatorView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.08.2024.
//

import SwiftUI

struct SignUpLogInCoordinatorView: View {
    @StateObject var coordinator = SignUpLogInCoordinator()
    
    var body: some View {
        NStack(stack: $coordinator.stack) { screens in
            switch screens {
            case .authentication:
                AuthenticationView()
            case .signUp:
                SignUpLogInView(title: "Sign Up", isLogin: false)
            case .logIn:
                SignUpLogInView(title: "Log In", isLogin: true)
            }
        }
        .environmentObject(coordinator)
        .customBackButton()
        
    }
}

#Preview {
    SignUpLogInCoordinatorView()
}
