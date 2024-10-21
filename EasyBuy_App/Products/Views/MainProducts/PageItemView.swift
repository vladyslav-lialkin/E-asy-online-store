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
    
    @ObservedObject var coordinator: MainTabCoordinator
    
    var body: some View {
        VStack {
            Spacer()
            ImageLoader(url: url)
            Spacer()
                                    
            Text(title)
                .customStroke(strokeSize: 2, strokeColor: .app)
                .font(.title.bold())
                .foregroundStyle(.letter)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
            
            HStack {
                Text("Price " + price)
                    .customStroke(strokeSize: 1.2, strokeColor: .app)
                    .foregroundStyle(.letter)
                
                Spacer()
                
                Button {
                    coordinator.productsStack.append(.product(id))
                } label: {
                    Text("Buy")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.letter)
                        .background {
                            Capsule()
                                .fill(Color.app)
                                .padding(.horizontal, -15)
                                .padding(.vertical, -7)
                            
                        }
                }
                .overlay {
                    Capsule()
                        .stroke(Color.border, lineWidth: 1)
                        .padding(.horizontal, -15)
                        .padding(.vertical, -7)
                }
                .frame(width: 65, height: 40)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(Color.banerBottom)
        }
        .background(Color(uiColor: .systemBackground))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.border, lineWidth: 1)
        }
        .clipShape(.rect(cornerRadius: 30))
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
