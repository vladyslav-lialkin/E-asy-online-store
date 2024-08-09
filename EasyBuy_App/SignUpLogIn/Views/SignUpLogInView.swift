//
//  SignUpLogInView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.08.2024.
//

import SwiftUI

struct SignUpLogInView: View {
    @EnvironmentObject var coordinator: SignUpLogInCoordinator
    @State var title: String
    @State var isLogin: Bool
    
    var body: some View {
        VStack {
            Text(title)
            
            Button {
                if isLogin {
                    coordinator.push(.signUp)
                } else {
                    coordinator.push(.logIn)
                }
            } label: {
                Text("Navigation to " + (isLogin ? "Sign Up" : "Log In"))
            }
        }
        .navigationTitle(title)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "bag")
                        .foregroundStyle(Color("AppColor"))
                }

            }
        })
    }
    
    
}

#Preview {
    SignUpLogInView(title: "Sign In", isLogin: false)
        .environmentObject(SignUpLogInCoordinator())
}

