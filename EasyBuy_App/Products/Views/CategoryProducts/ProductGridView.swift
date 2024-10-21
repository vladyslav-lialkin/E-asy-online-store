//
//  ProductGridItem.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI

struct ProductGridView: View {
    let url: URL?
    let title: String
    let price: Double
    let id: UUID
    
    let coordinator: MainTabCoordinator
    
    var body: some View {
        Button {
            coordinator.productsStack.append(.product(id))
        } label: {
            VStack {
                Spacer()
                ImageLoader(url: url)
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 15)
                    Text(title)
                        .customStroke(strokeSize: 1, strokeColor: .app)
                        .font(.callout.bold())
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    Text("Price $" + String(format: "%.2f", price))
                        .customStroke(strokeSize: 0.8, strokeColor: .app)
                        .font(.caption)
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Spacer()
                        .frame(height: 15)
                }
                .background(.banerBottom)
            }
            .background(Color(uiColor: .systemBackground))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.border, lineWidth: 1)
        }
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    VStack {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        LazyVGrid(columns: columns) {
            ProductGridView(url: URL(string: "https://i.imgur.com/RvgrlFp.png"),
                            title: "MacBook Air 2020",
                            price: 999.99,
                            id: UUID(),
                            coordinator: MainTabCoordinator())
            .frame(height: 300)
        }
        .padding()
    }
}
