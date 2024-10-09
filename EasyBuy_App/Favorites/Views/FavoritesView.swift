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
            
            if !viewModel.favorites.isEmpty {
                ScrollView {
                    Spacer()
                        .padding(.top)
                    
                    ForEach(viewModel.favorites) { favorite in
                        FavoriteItem(viewModel: viewModel,
                                     coordinator: coordinator,
                                     favorite: favorite)
                    }
                    
                    Spacer()
                        .padding(.bottom)
                }
                .refreshable {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await viewModel.reloadData()
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
        .animation(.easeInOut, value: viewModel.favorites)
        .navigationTitle("Favorites")
        .task {
            await viewModel.reloadData()
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
