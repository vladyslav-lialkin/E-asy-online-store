//
//  AuthenticationView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 06.08.2024.
//

import SwiftUI

struct AuthenticationView: View {
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
                
                Text("title")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("description")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(AppColors.adaptiveGradient,
                                    lineWidth: 1)
                            .overlay {
                                Text("sign_up")
                                    .foregroundStyle(AppColors.gradient)
                            }
                            .brightness(-0.3)
                    }
                    
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(AppColors.gradient)
                            .brightness(-0.3)
                            .overlay {
                                Text("log_in")
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
}
