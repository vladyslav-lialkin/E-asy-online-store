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
    
    let height = UIScreen.main.bounds.size.height
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 30)
                
                if !viewModel.products.isEmpty {
                    ForEach(viewModel.products) { product in
                        FavoriteItem(action: viewModel.deleteFavorite(for: product.id),
                                     url: product.imagesUrl.first,
                                     title: product.name,
                                     price: product.price,
                                     id: product.id,
                                     coordinator: coordinator)
                    }
                    .transition(.moveAndFade)
                } else {
                    VStack {
                        Spacer()
                            .frame(height: height * 0.28)
                        
                        Text("It's empty for now")
                            .foregroundStyle(.letter)
                            .customStroke(strokeSize: 1, strokeColor: .app)
                        
                        Button {
                            coordinator.activeTab = .products
                        } label: {
                            Text("add to favorites")
                                .font(.body.bold())
                                .foregroundStyle(.letter)
                                .background {
                                    Capsule()
                                        .fill(.app)
                                        .padding(.horizontal, -10)
                                        .padding(.vertical, -5)
                                }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Favorites")
            .animation(.easeInOut, value: viewModel.products)
        }
        .refreshable {
            await Task {
                await viewModel.startFavorites()
            }.value
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .background(.customBackground)
        .task {
            await viewModel.startFavorites()
        }
    }
}

#Preview {
    NavigationView {
        FavoritesView()
            .environmentObject(MainTabCoordinator())
    }
    .navigationViewStyle(.stack)
}
