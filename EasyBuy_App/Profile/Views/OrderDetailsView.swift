//
//  OrderDetailsView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import SwiftUI

struct OrderDetailsView: View {
    @ObservedObject private var viewModel: OrderDetailsViewModel
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            if let order = viewModel.order {
                ScrollView {
                    Spacer().padding(.top)
                    
                    Text("Order № " + order.id.uuidString.prefix(8))
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .padding(.horizontal)
                    
                    ForEach(0..<order.quantity, id: \.self) { _ in
                        itemOrder(order)
                    }
                    
                    VStack {
                        summaryRow(title: "Total Items (\(order.quantity))",
                                   value: "$" + String(format: "%.2f", order.price * Double(order.quantity)))
                        summaryRow(title: "Delivery Fee",
                                   value: "Free")
                        summaryRow(title: "Promo Code",
                                   value: "-0%")
                        summaryRow(title: "Total",
                                   value: "$" + String(format: "%.2f", order.price * Double(order.quantity)))
                    }
                    .padding()
                    .background(Color.app.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                    Button {} label: {
                        Text("Order Traking")
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
                    
                    Spacer().padding(.bottom)
                }
                .refreshable {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await viewModel.startOrder()
                }
            } else {
                Text("Order not found")
                    .font(.title2.bold())
                    .foregroundStyle(.red)
            }
        }
        .navigationTitle("Order Details")
        .task {
            await viewModel.startOrder()
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
    
    init(id: UUID) {
        viewModel = OrderDetailsViewModel(id: id)
    }
    
    // MARK: - Item Order
    func itemOrder(_ order: Order) -> some View {
        Button {
            coordinator.productsStack.append(.product(order.productID))
            coordinator.activeTab = .products
        } label: {
            HStack {
                AsyncImageView(url: order.imageUrl)
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
                
                VStack(spacing: 3) {
                    Text(order.name)
                        .customStroke(strokeSize: 1, strokeColor: .app)
                        .font(.callout.bold())
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                    
                    HStack {
                        Text("Price $" + String(format: "%.2f", order.price))
                            .customStroke(strokeSize: 0.8, strokeColor: .app)
                            .font(.caption)
                            .foregroundStyle(.letter)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("1")
                            .frame(width: 30)
                            .lineLimit(1)
                    }
                }
                .padding(.leading)
            }
            .frame(height: 110)
            .padding(.trailing)
            .roundedButton(cornerRadius: 10)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Summary Row
    func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        OrderDetailsView(id: UUID(uuidString: "9CA0C3B0-CB5A-4D4B-BB33-81AE55448DD3")!)
            .environmentObject(MainTabCoordinator())
    }
    .tint(.app)
}
