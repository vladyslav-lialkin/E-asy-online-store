//
//  ProductSummaryView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 11.09.2024.
//

import SwiftUI

struct ProductSummaryView: View {
    @ObservedObject var viewModel: ProductViewModel
    let product: Product
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 55)
            
            HStack {
                Text(product.name)
                    .customStroke(strokeSize: 2, strokeColor: .app)
                    .font(.title.bold())
                    .foregroundStyle(.letter)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Button {
                    viewModel.favorite != nil ? viewModel.deleteFavorite() : viewModel.addToFavorite()
                } label: {
                    Image(systemName: viewModel.favorite != nil ? "heart.fill" : "heart")
                        .font(.title.bold())
                        .foregroundStyle(.app)
                        .background(.letter)
                        .mask {
                            Image(systemName: "heart.fill")
                                .font(.title.bold())
                        }
                }
                .animation(.easeInOut, value: viewModel.favorite)
            }
            
            HStack {
                Text("Price " + String(format: "%.2f", product.price))
                    .customStroke(strokeSize: 1.2, strokeColor: .app)
                    .foregroundStyle(.letter)
                
                Spacer()
                
                Button {
                    viewModel.addToBag()
                } label: {
                    Text("Add To Bag")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.letter)
                        .background {
                            Capsule()
                                .fill(Color.app)
                                .padding(.vertical, -10)
                                .padding(.horizontal, -12)
                        }
                }
                .overlay {
                    Capsule()
                        .stroke(Color.border, lineWidth: 1)
                        .padding(.vertical, -10)
                        .padding(.horizontal, -12)
                }
                .padding(.trailing, 10)
            }
            .padding(.vertical)
            
            Divider()
                .customStroke(strokeSize: 0.15, strokeColor: .app)
            
            Text("Description")
                .customStroke(strokeSize: 1.6, strokeColor: .app)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.letter)
            
            Text(product.description)
                .customStroke(strokeSize: 1.2, strokeColor: .app)
                .foregroundStyle(.letter)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, -5)
        }
    }
}

#Preview {
    NavigationView {
        ProductView(id: UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")!)
    }
}
