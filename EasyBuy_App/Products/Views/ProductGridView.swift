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
        VStack {
            Spacer()
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Spacer()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Text("Failed to load image")
                        .foregroundColor(.red)
                @unknown default:
                    Text("Unknown error")
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
                                    
            Text(title)
                .font(.callout.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            HStack {
                Text("Price $" + String(format: "%.2f", price))
                    .font(.caption)
                    .padding(.leading)
                
                Spacer()
                
                Button {
                    coordinator.productsStack.append(.product(id))
                } label: {
                    Text("Buy")
                        .font(.caption)
                        .foregroundStyle(Color.lable)
                        .background {
                            Capsule()
                                .fill(Color.customBackground)
                                .frame(width: 45, height: 30)
                        }
                }
                .frame(width: 45, height: 30)
                .padding(.trailing)
            }
            .frame(height: 40)
            .background(Color.itemBackground)
        }
        .clipShape(.rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.border, lineWidth: 1)
        }
    }
}

#Preview {
    VStack {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        LazyVGrid(columns: columns) {
            ProductGridView(url: URL(string: "https://i.imgur.com/RvgrlFp.png"),
                            title: "iPhone 15 pro",
                            price: 999.99,
                            id: UUID(),
                            coordinator: MainTabCoordinator())
            .frame(height: 300)
        }
        .padding()
    }
}
