//
//  FavoriteItem.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 18.09.2024.
//

import SwiftUI

struct FavoriteItem: View {
    @State var event = true
    
    @ObservedObject var viewModel: FavoritesViewModel
    let coordinator: MainTabCoordinator
    let favorite: Favorite
    
    var body: some View {
        Button {
            coordinator.favouritesStack.append(.product(favorite.productID))
        } label: {
            HStack {
                AsyncImageView(url: favorite.imageUrl)
                    .frame(width: 100)
                
                VStack {
                    Text(favorite.name)
                        .customStroke(strokeSize: 1, strokeColor: .app)
                        .font(.callout.bold())
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    Text("Price $" + String(format: "%.2f", favorite.price))
                        .customStroke(strokeSize: 0.8, strokeColor: .app)
                        .font(.caption)
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                Button {
                    event = false
                    viewModel.deleteFavorite(for: favorite.id)
                } label: {
                    Group {
                        if event {
                            Image(systemName: "heart.fill")
                                .resizable()
                        } else {
                            Image(systemName: "heart")
                                .resizable()
                        }
                    }
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundStyle(.app)
                }
            }
            .frame(height: 100)
            .padding(.horizontal)
            .background(.itemBackground)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.border, lineWidth: 1)
            }
            .clipShape(.rect(cornerRadius: 20))
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        FavoritesView()
            .environmentObject(MainTabCoordinator())
    }
    .navigationViewStyle(.stack)
}
