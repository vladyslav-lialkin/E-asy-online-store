//
//  CheckoutView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.11.2024.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel = CheckoutViewModel()
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    @FocusState private var focus: Bool
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    Spacer()
                        .padding(.top)
                    
                    Text("Shipped Address")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    quickActionButton {
                        //
                    } label: {
                        VStack {
                            if let user = viewModel.user,
                               let name = user.name,
                               let lastname = user.lastname,
                               let phoneNumber = user.phoneNumber,
                               let address = user.address,
                               let city = user.city,
                               let country = user.country,
                               let postalCode = user.postalcode {
                                Group {
                                    Text(name + " " + lastname + ", " + phoneNumber)
                                    Text(address)
                                    Text(city + ", " + country + ", " + postalCode)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text("Enter your address")
                                    .font(.headline.bold())
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    Text("Shipping method")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        Group {
                            Text("Shipping: Free shipping")
                            Text("Delivery: 1-2 days")
                            Text("Countrier company: Nova, Meest, etc.")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.callout.bold())
                        .foregroundStyle(.app)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    ForEach($viewModel.selectedBags) { $bag in
                        itemBag($bag)
                    }
                    .onChange(of: viewModel.selectedBags) { value in
                        if value.isEmpty {
                            coordinator.bagStack.removeLast()
                        }
                    }
                    
                    VStack {
                        Text("Enter promo code")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Enter promo code", text: $viewModel.promoCode)
                            .focused($focus)
                            .customTextField(color: viewModel.errorPromoCode != nil ? .red : .gray)
                        
                        if let errorEmail = viewModel.errorPromoCode {
                            Text(errorEmail)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                        }
                    }
                    .padding(.vertical)
                    
                    VStack {
                        summaryRow(title: "Subtotal Items (\(viewModel.selectedBags.count))",
                                   value: "$" + String(format: "%.2f", viewModel.selectedBags.reduce(0.00) { $0 + ($1.price * Double($1.quantity)) }))
                        summaryRow(title: "Promo Code",
                                   value: "-0%")
                        summaryRow(title: "Delivery Fee",
                                   value: "Free")
                    }
                    .padding()
                    .background(Color.app.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                                        
                    Spacer()
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                
                checkoutBottomBar()
            }
        }
        .navigationTitle("Order confirmation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("done") {
                    focus = false
                }
            }
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
    
    // MARK: - Item Bag
    private func itemBag(_ bag: Binding<Bag>) -> some View {
        HStack {
            ImageLoader(url: bag.wrappedValue.imageUrl)
                .frame(width: 100, height: 68)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.border, lineWidth: 1)
                        .background(Color.customBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, -5)
                        .padding(.vertical, -10)
                }
                .padding(.leading, 17)
            
            VStack {
                Text(bag.wrappedValue.name)
                    .customStroke(strokeSize: 1, strokeColor: .app)
                    .font(.callout.bold())
                    .foregroundStyle(.letter)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Text("Price $" + String(format: "%.2f", bag.wrappedValue.price))
                    .customStroke(strokeSize: 0.8, strokeColor: .app)
                    .font(.caption)
                    .foregroundStyle(.letter)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    HStack {
                        Button {
                            viewModel.updateBag(for: bag, .subtractQuantity)
                        } label: {
                            Text("-")
                        }
                        
                        Text("\(bag.wrappedValue.quantity)")
                            .foregroundStyle(.app)
                            .frame(width: 30)
                            .lineLimit(1)
                        
                        Button {
                            viewModel.updateBag(for: bag, .addQuantity)
                        } label: {
                            Text("+")
                        }
                    }
                    .background {
                        Capsule()
                            .stroke(.border, lineWidth: 1)
                            .background(Color.customBackground)
                            .clipShape(Capsule())
                            .padding(.horizontal, -10)
                            .padding(.vertical, -5)
                            .offset(y: 1)
                    }
                    .frame(height: 30)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    
                    Spacer()
                    
                    Button {
                        viewModel.deleteBag(for: bag.id)
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 110)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.border, lineWidth: 1)
                .background(Color.itemBackground)
                .clipShape(.rect(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
    
    // MARK: - Checkout Bottom Bar
    private func checkoutBottomBar() -> some View {
        HStack {
            Text("Total " + String(format: "%.2f", viewModel.selectedBags.reduce(0.00) { $0 + ($1.price * Double($1.quantity)) }))
            .customStroke(strokeSize: 1.5, strokeColor: .app)
            .foregroundStyle(.letter)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                viewModel.buyAllSelected {
                    coordinator.bagStack.removeLast()
                }
            } label: {
                Text("Pay Now")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.letter)
                    .background {
                        Capsule()
                            .stroke(Color.border, lineWidth: 1)
                            .background(Color.app)
                            .clipShape(Capsule())
                            .padding(.vertical, -7)
                            .padding(.horizontal, -12)
                    }
            }
            .disabled(viewModel.isEmptyAddress)
            .padding(.trailing, 28)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.border, lineWidth: 1)
                .background(Color.itemBackground)
                .clipShape(.rect(cornerRadius: 10))
        }
        .padding(.horizontal, 5)
    }
    
    // MARK: - Summary Row
    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Buttons    
    func quickActionButton(_ action: @escaping () -> Void, label: @escaping () -> some View) -> some View {
        Button {
            action()
        } label: {
            HStack {
                label()
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .font(.callout.bold())
            .padding(.horizontal, 17)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.border, lineWidth: 1)
                    .background(Color.itemBackground)
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    NavigationView {
        CheckoutView()
            .environmentObject(MainTabCoordinator())
            .onAppear {
                if !KeychainHelper.save(token: "1Ibk0EWNvnEzq/g6aJwCXA==") {
                    print("Token is Error")
                }
            }
    }
    .tint(.app)
}
