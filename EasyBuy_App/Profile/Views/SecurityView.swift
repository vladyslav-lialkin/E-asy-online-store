//
//  SecurityView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 10.10.2024.
//

import SwiftUI

enum FocusField: String, Hashable {
    case currentPassword = "Current"
    case newPassword = "New"
    case confirmPassword = "Confirm"
}

struct SecurityView: View {
    @StateObject private var viewModel = SecurityViewModel()
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack {
                        Spacer().padding(.top)
                        
                        Text("Current Password")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        SecureTextField("enter_password", password: $viewModel.currentPassword)
                            .focused($focusedField, equals: .currentPassword)
                            .customTextField(color: viewModel.errorCurrentPassword != nil ? .red : .gray)
                        
                        if let errorPassword = viewModel.errorCurrentPassword {
                            Text(errorPassword)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                        }
                        
                        Spacer()
                            .padding(.top)
                            .id("Current")
                            .onChange(of: focusedField) { value in
                                if let value {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.linear) {
                                            proxy.scrollTo(value.rawValue, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        
                        Text("New Password")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        SecureTextField("enter_password", password: $viewModel.newPassword)
                            .focused($focusedField, equals: .newPassword)
                            .customTextField(color: viewModel.errorNewPassword != nil ? .red : .gray)
                        
                        if let errorPassword = viewModel.errorNewPassword {
                            Text(errorPassword)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                        }
                        
                        Spacer()
                            .padding(.top)
                            .id("New")
                        
                        Text("Confirm Password")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        SecureTextField("enter_password", password: $viewModel.confirmPassword)
                            .focused($focusedField, equals: .confirmPassword)
                            .customTextField(color: viewModel.errorConfirmPassword != nil ? .red : .gray)
                        
                        if let errorPassword = viewModel.errorConfirmPassword {
                            Text(errorPassword)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                        }
                        
                        Spacer()
                            .padding(.top)
                            .id("Confirm")
                    }
                }
                
                Button {
                    focusedField = nil
                    viewModel.changePassword()
                } label: {
                    Text("Update Password")
                        .foregroundColor(.letter)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(Color.app)
                        }
                }
                .padding()
            }
            
            if viewModel.isSuccess {
                HStack {
                    Text("Saved")
                        .font(.title.bold())
                        .foregroundColor(.green)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 20)
                }
                .padding()
                .background {
                    Color.green
                        .clipShape(.rect(cornerRadius: 10))
                        .opacity(0.1)
                }
                .zIndex(1)
                .transition(.scale)
                .animation(.easeInOut(duration: 0.5), value: viewModel.isSuccess)
            }
        }
        .navigationTitle("Security")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if focusedField != nil {
                    Button(action: {
                        focusedField = nil
                    }) {
                        Text("done")
                            .foregroundColor(Color.app)
                    }
                }
            }
        }
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .showProgressView(isLoading: viewModel.isLoading, background: false)
    }
}

#Preview {
    SecurityView()
}
