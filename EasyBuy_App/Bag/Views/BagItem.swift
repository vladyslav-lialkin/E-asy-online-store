//
//  BagItem.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.09.2024.
//

import SwiftUI

struct BagItem: View {
    let action: () -> Void
    let product: Product
    let coordinator: MainTabCoordinator
    
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
            .padding(.horizontal)
            .background(.itemBackground)
            .clipShape(.rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.border, lineWidth: 1)
            }
        }
        .padding(.horizontal)
    }
    
    init(action: @autoclosure @escaping () -> Void, product: Product, coordinator: MainTabCoordinator) {
        self.action = action
        self.product = product
        self.coordinator = coordinator
    }
}

#Preview {
    ScrollView{
        ForEach(0..<5) { _ in
            FavoriteItem(action: print(true),
                         url: URL(string: "https://i.imgur.com/RvgrlFp.png"),
                         title: "MacBook Air 2020",
                         price: 999.99,
                         id: UUID(),
                         coordinator: MainTabCoordinator())
        }
    }
    .background(.customBackground)
    
}
