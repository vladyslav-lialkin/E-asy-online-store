//
//  BagItem.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.09.2024.
//

import SwiftUI

struct BagItem: View {
    @ObservedObject var viewModel: BagViewModel
    let coordinator: MainTabCoordinator
    let product: Product
    
    var body: some View {
        Button {
            coordinator.favouritesStack.append(.product(product.id))
        } label: {
            HStack {
                AsyncImageView(url: product.imagesUrl.first)
                    .frame(width: 100)
                
                VStack {
                    Text(product.name)
                        .customStroke(strokeSize: 1, strokeColor: .app)
                        .font(.callout.bold())
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    Text("Price $" + String(format: "%.2f", product.price))
                        .customStroke(strokeSize: 0.8, strokeColor: .app)
                        .font(.caption)
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
            .frame(height: 100)
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
