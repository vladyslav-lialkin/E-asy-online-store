//
//  AuthenticationView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 06.08.2024.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var coordinator: SignUpLogInCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            VStack(spacing: 10) {
                Spacer()
                Image("AppleProducts")
                    .resizable()
                    .scaledToFill()
                    .frame(height: height/2)
                    .offset(x: -80)
                
                Image("E-ASY")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("authentication_title")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("authentication_description")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 20) {
                    Button {
                        coordinator.stack.append(.signUp)
                    } label: {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color("AppColor"),
                                    lineWidth: 1)
                            .overlay {
                                Text("authentication_sign_up")
                                    .foregroundStyle(Color("AppColor"))
                            }
                    }
                    
                    Button {
                        coordinator.stack.append(.logIn)
                    } label: {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color("AppColor"))
                            .overlay {
                                Text("authentication_log_in")
                                    .foregroundStyle(.background)
                            }
                    }
                    
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
            }
            .frame(width: width, height: height)
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(SignUpLogInCoordinator())
}
