//
//  ShippingAddressView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 06.11.2024.
//

import SwiftUI

struct ShippingAddressView: View {
    @StateObject private var viewModel = ShippingAddressViewModel()
    @FocusState private var focus: Bool
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    Spacer()
                        .padding(.top)
                    
                    VStack {
                        Text("Country")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Enter", text: $viewModel.country)
                            .focused($focus)
                            .customTextField(color: .app)
                        
                        HStack {
                            Text("First name")
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Last name")
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack {
                            TextField("Enter", text: $viewModel.name)
                                .focused($focus)
                                .customTextField(color: .app)
                            
                            TextField("Enter", text: $viewModel.lastname)
                                .focused($focus)
                                .customTextField(color: .app)
                        }
                        
                        Text("Address (Street, Building, Floor*, Apartment*)")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("e.g., Main St. 123, Floor 2, Apt. 45", text: $viewModel.address)
                            .focused($focus)
                            .customTextField(color: .app)
                        
                        Text("City and Region / State")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        TextField("e.g., New York, NY", text: $viewModel.city)
                            .focused($focus)
                            .customTextField(color: .app)
                        
                        Text("Postal Code")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Enter", text: $viewModel.postalcode)
                            .focused($focus)
                            .customTextField(color: .app)
                        
                        Text("Mobile number")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("e.g., +1 234 567 8901", text: $viewModel.phoneNumber)
                            .focused($focus)
                            .customTextField(color: .app)
                    }
                    
                    Spacer()
                        .padding(.bottom)
                }
                
                Button {
                    viewModel.updateUserAddress()
                } label: {
                    Text("Update")
                        .foregroundColor(.letter)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(Color.app)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                }
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
                        .opacity(0.2)
                }
                .zIndex(1)
                .transition(.scale)
                .animation(.easeInOut(duration: 0.5), value: viewModel.isSuccess)
            }
        }
        .navigationTitle("Shipping Address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("done") {
                    focus = false
                }
            }
        }
        .task {
            await viewModel.reloadData()
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
}

#Preview {
    NavigationView {
        ShippingAddressView()
            .environmentObject(MainTabCoordinator())
            .onAppear {
                if !KeychainHelper.save(token: "1Ibk0EWNvnEzq/g6aJwCXA==") {
                    print("Token is Error")
                }
            }
    }
    .tint(.app)
}
