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
    @Environment(\.colorScheme) private var scheme
    
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
                
                Text(viewModel.description)
                    .padding(.horizontal)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                let height = UIScreen.main.bounds.height
                Spacer()
                    .frame(
                        height: viewModel.isLogin ? (focus ? 10 : height/8) : (focus ? 10 : height/16)
                    )
                
                if !viewModel.isLogin {
                    Text("Username")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Enter Username", text: $viewModel.username)
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
                
                Text("Email Address")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Enter Email", text: $viewModel.email)
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
                
                
                Text("Password")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureTextField("Password", password: $viewModel.password)
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
                    Task {
                        viewModel.isLoading = true
                        do {
                            try await viewModel.isLogin ? viewModel.logIn() : viewModel.signUp()
                        } catch let error as HttpError {
                            viewModel.handleHttpError(error)
                        } catch {
                            print("An unexpected error occurred: \(error)")
                        }
                        viewModel.isLoading = false
                        appState.checkAuthentication {
                            coordinator.stack.removeAll()
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color("AppColor"))
                        .overlay {
                            Text(viewModel.buttonTitle)
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
                    
                    Text("Or sign in with")
                    
                    VStack {
                        Divider()
                            .padding(.trailing)
                    }
                }.foregroundStyle(.gray)
                
                HStack {
                    Button {
                        focus = false
                        Task {
                            viewModel.isLoading = true
                            do {
                                try await viewModel.signInWithGoogle()
                            } catch let error as HttpError {
                                viewModel.handleHttpError(error)
                            } catch {
                                print("An unexpected error occurred: \(error)")
                            }
                            viewModel.isLoading = false
                            appState.checkAuthentication {
                                coordinator.stack.removeAll()
                            }
                        }
                    } label: {
                        Capsule()
                            .stroke(Color.gray, lineWidth: 1)
                            .overlay {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28)
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                    }
                    .frame(width: 50, height: 50)
                    .disabled(viewModel.errorMessage != nil)
                    
                    Button {
                        
                    } label: {
                        Capsule()
                            .stroke(Color.gray, lineWidth: 1)
                            .overlay {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22)
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                    }
                    .frame(width: 50, height: 50)
                    .disabled(viewModel.errorMessage != nil)
                }
                
                HStack {
                    Text(viewModel.botomDescription)
                    
                    Button {
                        if viewModel.isLogin {
                            coordinator.push(.signUp)
                        } else {
                            coordinator.push(.logIn)
                        }
                    } label: {
                        if viewModel.isLogin {
                            Text("Register")
                        } else {
                            Text("Sign In")
                        }
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
                        Text("Done")
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
