//
//  OrdersView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.10.2024.
//

import SwiftUI

struct OrdersView: View {
    @StateObject private var viewModel: OrdersViewModel
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            if !viewModel.orders.isEmpty {
                ScrollView {
                    Spacer()
                        .padding(.top)
                    
                    ForEach(viewModel.orders) { order in
                        itemOrder(order)
                    }
                    
                    Spacer()
                        .padding(.bottom)
                }
                .refreshable {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await viewModel.startOrders()
                }
            } else {
                VStack {
                    Image(systemName: "list.bullet.clipboard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .foregroundStyle(.app)
                        .opacity(0.8)
                    
                    Text("Your orders is empty")
                        .font(.title2.bold())
                        .foregroundStyle(.letter)
                        .customStroke(strokeSize: 2, strokeColor: .app)
                }
            }
        }
        .navigationTitle("Orders")
        .task {
            await viewModel.startOrders()
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
    
    init(statuses: [StatusOrderEnum]) {
        _viewModel = StateObject(wrappedValue: OrdersViewModel(statuses: statuses))
    }
    
    // MARK: - Item Order
    func itemOrder(_ order: Order) -> some View {
        Button {
            coordinator.profileStack.append(.order(order.id))
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
                        
                        Text("x\(order.quantity)")
                            .frame(width: 30)
                            .lineLimit(1)
                    }
                    
                    Text(order.statusOrder)
                        .font(.callout.bold())
                        .foregroundStyle(StatusOrderEnum(rawValue: order.statusOrder)?.color ?? .green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading)
            }
            .frame(height: 110)
            .padding(.trailing)
            .roundedButton(cornerRadius: 10)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationView {
        OrdersView(statuses: [.all])
            .environmentObject(MainTabCoordinator())
    }
    .tint(.app)
}
