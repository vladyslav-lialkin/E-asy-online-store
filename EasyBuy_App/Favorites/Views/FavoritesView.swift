//
//  FavoritesView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            if !viewModel.products.isEmpty {
                ScrollView {
                    ForEach(viewModel.products) { product in
                        FavoriteItem(action: viewModel.deleteFavorite(for: product.id),
                                     url: product.imagesUrl.first,
                                     title: product.name,
                                     price: product.price,
                                     id: product.id,
                                     coordinator: coordinator)
                    }
                }
                .refreshable {
                    await Task {
                        await viewModel.startFavorites()
                    }.value
                }
            } else {
                VStack {
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .foregroundStyle(.app)
                        .opacity(0.8)
                    
                    Text("Your favorites is empty")
                        .font(.title2.bold())
                        .foregroundStyle(.letter)
                        .customStroke(strokeSize: 2, strokeColor: .app)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.products)
        .navigationTitle("Favorites")
        .task {
            await viewModel.startFavorites()
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
}

#Preview {
    NavigationView {
        FavoritesView()
            .environmentObject(MainTabCoordinator())
    }
    .navigationViewStyle(.stack)
}
