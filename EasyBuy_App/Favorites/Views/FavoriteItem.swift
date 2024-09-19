//
//  FavoriteItem.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 18.09.2024.
//

import SwiftUI

struct FavoriteItem: View {
    @State var event = true
    
    let action: () -> Void
    let url: URL?
    let title: String
    let price: Double
    let id: UUID
    let coordinator: MainTabCoordinator
    
    var body: some View {
        Button {
            coordinator.favouritesStack.append(.product(id))
        } label: {
            HStack {
                AsyncImageView(url: url)
                    .frame(width: 100)
                
                VStack {
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
                }
                
                Button {
                    event = false
                    action()
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
            .clipShape(.rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.border, lineWidth: 1)
            }
        }
        .padding(.horizontal)
    }
    
    init(action: @autoclosure @escaping () -> Void, url: URL?, title: String, price: Double, id: UUID, coordinator: MainTabCoordinator) {
        self.action = action
        self.url = url
        self.title = title
        self.price = price
        self.id = id
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
