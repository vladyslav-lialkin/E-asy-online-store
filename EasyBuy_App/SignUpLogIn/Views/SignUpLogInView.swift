//
//  SignUpLogInView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.08.2024.
//

import SwiftUI

struct SignUpLogInView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var coordinator: SignUpLogInCoordinator
    
    @StateObject var viewModel: SignUpLogInViewModel    
    @FocusState var focus: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal)
                
                Text(viewModel.descriptionText)
                    .padding(.horizontal)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                let height = UIScreen.main.bounds.height
                Spacer()
                    .frame(
                        height: viewModel.isLogin ? (focus ? 10 : height/8) : (focus ? 10 : height/16)
                    )
                
                if !viewModel.isLogin {
                    Text("username")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("enter_username", text: $viewModel.username)
                        .focused($focus)
                        .customTextField(color: viewModel.errorUsername != nil ? .red : .gray)
                    
                    if let errorUsername = viewModel.errorUsername {
                        Text(errorUsername)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                    }
                }
                
                Text("email_address")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("enter_email", text: $viewModel.email)
                    .focused($focus)
                    .customTextField(color: viewModel.errorEmail != nil ? .red : .gray)
                
                if let errorEmail = viewModel.errorEmail {
                    Text(errorEmail)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                }
                
                
                Text("password")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureTextField("password", password: $viewModel.password)
                    .focused($focus)
                    .customTextField(color: viewModel.errorPassword != nil ? .red : .gray)
                
                if let errorPassword = viewModel.errorPassword {
                    Text(errorPassword)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                }
                
                
                Button {
                    focus = false
                    viewModel.isLoading = true
                    Task {
                        do {
                            try await viewModel.isLogin ? viewModel.logIn() : viewModel.signUp()
                        } catch let error as HttpError {
                            viewModel.handleHttpError(error)
                        } catch {
                            print("An unexpected error occurred: \(error)")
                        }
                        viewModel.isLoading(false)
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color("AppColor"))
                        .overlay {
                            Text(viewModel.primaryButtonTitle)
                                .foregroundStyle(.background)
                        }
                }
                .frame(height: 50)
                .padding()
                .disabled(viewModel.errorMessage != nil)
                
                HStack {
                    VStack {
                        Divider()
                            .padding(.leading)
                    }
                    
                    Text("or_sign_in_with")
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                    
                    VStack {
                        Divider()
                            .padding(.trailing)
                    }
                }.foregroundStyle(.gray)
                
                HStack {
                    Button {
                        focus = false
                        viewModel.signInWithGoogle()
                    } label: {
                        Capsule(style: .circular)
                            .stroke(Color.gray, lineWidth: 1)
                            .overlay {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                    }
                    .frame(width: 50, height: 50)
                    .disabled(viewModel.errorMessage != nil)
                    
                    Button {
                        focus = false
//                        viewModel.signInWithFaceBook()
                    } label: {
                        Capsule(style: .circular)
                            .stroke(Color.gray, lineWidth: 1)
                            .overlay {
                                Image("facebook")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                    }
                    .frame(width: 50, height: 50)
                    .disabled(viewModel.errorMessage != nil)
                    
                    Button {
                        focus = false
                        viewModel.signInWithApple()
                    } label: {
                        Capsule(style: .circular)
                            .stroke(Color.gray, lineWidth: 1)
                            .overlay {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24)
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                    }
                    .frame(width: 50, height: 50)
                    .disabled(viewModel.errorMessage != nil)
                }
                
                HStack {
                    Text(viewModel.bottomDescriptionText)
                    
                    Button {
                        if viewModel.isLogin {
                            coordinator.push(.signUp)
                        } else {
                            coordinator.push(.logIn)
                        }
                    } label: {
                        Text(viewModel.secondaryButtonTitle)
                    }.foregroundStyle(Color("AppColor"))
                }
                
                Spacer()
                    .frame(height: 15)
            }
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut, value: focus)
            .background {
                Rectangle()
                    .fill(.background)
                    .frame(maxHeight: .infinity)
                    .ignoresSafeArea()
                    .gesture(
                        TapGesture()
                            .onEnded({ value in
                                focus = false
                            })
                    )
            }
            .onReceive(viewModel.$isLoading) { newValue in
                appState.checkAuthentication {
                    coordinator.stack.removeAll()
                }
            }
        }
        .overlay {
            if let message = viewModel.errorMessage {
                Text(message)
                    .foregroundColor(.red)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(uiColor: .systemGray2))
                            .opacity(0.9)
                    }
                    .frame(width: 230)
            }
        }
        .overlay {
            if viewModel.errorMessage == nil, viewModel.isLoading {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(uiColor: .systemGray2))
                    .opacity(0.8)
                    .overlay {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.6)
                            .progressViewStyle(.circular)
                    }
                    .frame(width: 50, height: 50, alignment: .center)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if focus {
                    Button(action: {
                        focus = false
                    }) {
                        Text("done")
                            .foregroundColor(Color("AppColor"))
                    }
                }
            }
        }
    }
    
    init(isLogin: Bool) {
        _viewModel = StateObject(wrappedValue: SignUpLogInViewModel(isLogin: isLogin))
    }
}

#Preview {
    SignUpLogInView(isLogin: false)
        .environmentObject(SignUpLogInCoordinator())
        .environmentObject(AppState())
}
