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
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            if !viewModel.products.isEmpty {
                List {
                    ForEach(viewModel.products) { product in
                        Section {
                            BagItem(viewModel: viewModel,
                                    coordinator: coordinator,
                                    product: product)
                        }
                    }.transition(.moveAndFade)
                }
                .refreshable {
                    await Task {
                        await viewModel.startBags()
                    }.value
                }
            } else {
                Text("Bag's empty for now")
                    .foregroundStyle(.letter)
                    .customStroke(strokeSize: 1, strokeColor: .app)
            }
        }
        .animation(.easeInOut, value: viewModel.products)
        .navigationTitle("Bag")
        .task {
            await viewModel.startBags()
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
}

#Preview {
    NavigationView {
        BagView()
            .environmentObject(MainTabCoordinator())
    }
    .navigationViewStyle(.stack)
}
