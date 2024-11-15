//
//  CheckoutView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.11.2024.
//

import SwiftUI
import Stripe

struct CheckoutView: View {
    @StateObject private var viewModel = CheckoutViewModel()
    @EnvironmentObject var coordinator: MainTabCoordinator
    @FocusState private var focus: Bool
    
    @State var loading = false
    @State var paymentMethodParams: STPPaymentMethodParams?
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    Spacer().padding(.top)
                    
                    addressSection
                    shippingMethodSection
                    itemBagsSection
                    paymentMethodSection
                    promoCodeSection
                    summarySection
                    
                    Spacer().padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                
                checkoutBottomBar
            }
        }
        .navigationTitle("Order Confirmation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .task { await viewModel.reloadData() }
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .overlay { successPaymentOverlay }
        .showProgressView(isLoading: viewModel.isLoading)
    }
}

// MARK: - View Sections
private extension CheckoutView {
    @ViewBuilder
    var addressSection: some View {
        
        if !viewModel.isEmptyAddress {
            headerText(title: "Shipped Address")
        } else {
            headerText(title: "Shipped Address*")
                .foregroundStyle(.red)
        }
        quickActionButton {
            coordinator.bagStack.append(.shippingAddress)
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
    }
    
    @ViewBuilder
    var shippingMethodSection: some View {
        headerText(title: "Shipping Method")
        VStack(alignment: .leading, spacing: 4) {
            Text("Shipping: Free shipping")
            Text("Delivery: 1-2 days")
            Text("Courier company: Nova, Meest, etc.")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.callout.bold())
        .foregroundStyle(.app)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    var itemBagsSection: some View {
        ForEach($viewModel.selectedBags) { $bag in
            ItemCheckoutView(bag: $bag, viewModel: viewModel)
        }
        .onChange(of: viewModel.selectedBags) { value in
            if value.isEmpty { coordinator.bagStack.removeLast() }
        }
    }
    
    @ViewBuilder
    var paymentMethodSection: some View {
        if viewModel.isEnterCardDeteil == true || viewModel.isEnterCardDeteil == nil {
            headerText(title: "Payment Method")
        } else {
            headerText(title: "Payment Method*")
                .foregroundStyle(.red)
        }
        STPPaymentCardTextField.Representable(paymentMethodParams: $paymentMethodParams)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    var promoCodeSection: some View {
        VStack(alignment: .leading) {
            Text("Enter promo code")
                .padding(.horizontal)
            TextField("Enter promo code", text: $viewModel.promoCode)
                .focused($focus)
                .customTextField(color: .gray)
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    var summarySection: some View {
        VStack {
            summaryRow(title: "Subtotal Items (\(viewModel.selectedBags.count))",
                       value: String(format: "%.2f", viewModel.totalPrice))
            summaryRow(title: "Promo Code", value: "-0%")
            summaryRow(title: "Delivery Fee", value: "Free")
        }
        .padding()
        .background(Color.app.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

// MARK: - Bottom Bar
private extension CheckoutView {
    @ViewBuilder
    var checkoutBottomBar: some View {
        HStack {
            Text("Total \(String(format: "%.2f", viewModel.totalPrice))")
                .customStroke(strokeSize: 1.5, strokeColor: .app)
                .foregroundColor(.letter)
                .padding(.horizontal)
            
            Spacer()
                 
            if let paymentIntent = viewModel.paymentIntentParams {
                Button {
                    if viewModel.isPaymentMethodComplete(paymentMethodParams: paymentMethodParams) {
                        paymentIntent.paymentMethodParams = paymentMethodParams
                        loading = true
                    } else if viewModel.isEmptyAddress {
                        viewModel.errorMessage = "Enter shipped address"
                    } else {
                        viewModel.errorMessage = "Enter card details"
                    }
                } label: {
                    labelPaymentButtom(title: "Pay Now")
                }
                .paymentConfirmationSheet(
                    isConfirmingPayment: $loading,
                    paymentIntentParams: paymentIntent,
                    onCompletion: { status, paymentIntent, error in
                        viewModel.onCompletion(
                            status: status,
                            paymentIntent: paymentIntent,
                            error: error
                        ) {
                            coordinator.bagStack.removeLast()
                        }
                    }
                )
                .disabled(loading)
            } else {
                Button {} label: {
                    labelPaymentButtom(title: "Loading...")
                }
                .disabled(true)
            }
        }
        .animation(.linear(duration: 0.3), value: viewModel.paymentIntentParams)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.border, lineWidth: 1)
                .background(Color.itemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 5)
        .padding(.bottom)
    }
    
    @ViewBuilder
    func labelPaymentButtom(title: String) -> some View {
        Text(title)
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
            .padding(.trailing, 28)
    }
}

// MARK: - Toolbar and Overlay
private extension CheckoutView {
    var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") { focus = false }
        }
    }
    
    @ViewBuilder
    var successPaymentOverlay: some View {
        if viewModel.successPayment {
            HStack {
                Text("Success Payment")
                    .font(.title3.bold())
                    .foregroundColor(.green)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green)
                    .frame(width: 20)
            }
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(10)
            .transition(.scale)
            .animation(.easeInOut(duration: 0.5), value: viewModel.successPayment)
        }
    }
}

// MARK: - UI Components
private extension CheckoutView {
    @ViewBuilder
    private func headerText(title: String) -> some View {
        Text(title)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private func quickActionButton(
        _ action: @escaping () -> Void,
        label: @escaping () -> some View
    ) -> some View {
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
    }
    .tint(.app)
}
