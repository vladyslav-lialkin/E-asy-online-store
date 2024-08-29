//
//  PageItem.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI

struct PageItemView: View {
    let url: URL?
    let title: String
    let price: String
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
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
            
            HStack {
                Text("From " + price)
                    .padding(.leading, 30)
                
                Spacer()
                
                Button {
                    coordinator.productsStack.append(.product(id))
                } label: {
                    Text("Buy")
                        .foregroundStyle(Color.lable)
                        .background {
                            Capsule()
                                .fill(Color.customBackground)
                                .frame(width: 65, height: 40)
                        }
                }
                .frame(width: 65, height: 40)
                .padding(.trailing, 30)
            }
            .frame(height: 60)
            .background(Color.itemBackground)
        }
        .clipShape(.rect(cornerRadius: 30))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.border, lineWidth: 1)
        }
        .padding(.horizontal)
        .padding(.all, 2)
    }
}

#Preview {
    PageItemView(url: URL(string: "https://i.imgur.com/RvgrlFp.png"),
             title: "iPhone 15 pro",
             price: "$999",
             id: UUID(),
             coordinator: MainTabCoordinator())
}
