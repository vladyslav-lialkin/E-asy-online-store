//
//  BagView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct BagView: View {
    @StateObject private var viewModel = BagViewModel()
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    let height = UIScreen.main.bounds.size.height
    
    var body: some View {
        ScrollView {
            VStack {
                if !viewModel.products.isEmpty {
                    ForEach(viewModel.products) { product in
                        BagItem(action: viewModel.deleteBag(for: product.id),
                                product: product,
                                coordinator: coordinator)
                    }
                    .onDelete(perform: { IndexSet in
                        viewModel.products.remove(atOffsets: IndexSet)
                        viewModel.bags.remove(atOffsets: IndexSet)
                    })
                    .transition(.moveAndFade)
                } else {
                    VStack {
                        Spacer()
                            .frame(height: height * 0.30)
                        
                        Text("Bag's empty for now")
                            .foregroundStyle(.letter)
                            .customStroke(strokeSize: 1, strokeColor: .app)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Bag")
            .animation(.easeInOut, value: viewModel.products)
        }
        .refreshable {
            await Task {
                await viewModel.startBags()
            }.value
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .background(.customBackground)
        .task {
            await viewModel.startBags()
        }
    }
}

#Preview {
    NavigationView {
        BagView()
            .environmentObject(MainTabCoordinator())
    }
    .navigationViewStyle(.stack)
}
