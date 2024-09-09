//
//  ProductDetailView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.09.2024.
//

import SwiftUI

struct ProductDetailView: View {
    @ObservedObject var viewModel: ProductViewModel
    let product: Product
    let size: CGSize
    let safeArea: EdgeInsets
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            let height = size.height * 0.4
            
            VStack {
                GeometryReader {
                    let minY = $0.frame(in: .global).minY
                    let minusY = -minY
                    let size = $0.size
                    let adjusted = minY - safeArea.top > 0 ? minY - safeArea.top : 0
                    
                    SwipeSlide(items: product.imagesUrl) {_, url in
                        AsyncImageView(url: url)
                            .frame(maxWidth: .infinity)
                            .frame(height: size.height + adjusted)
                    }
                    .offset(y: minusY + safeArea.top)
                    .overlay(alignment: .bottom) {
                        GeometryReader {_ in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.productBaner)
                                .offset(y: height + 10)
                                .frame(height: self.size.height + minusY)
                        }
                    }
                }
                .frame(height: height)
            }
            
            VStack {
                Spacer()
                    .frame(height: 30)
                
                HStack {
                    Text(product.name)
                        .customStroke(strokeSize: 2, strokeColor: .app)
                        .font(.title.bold())
                        .foregroundStyle(.customBackground)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                    
                    Button {
                        viewModel.favorite != nil ? viewModel.deleteFavorite() : viewModel.addToFavorite()
                    } label: {
                        Image(systemName: viewModel.favorite != nil ? "heart.fill" : "heart")
                            .font(.title.bold())
                            .foregroundStyle(.app)
                            .background(.customBackground)
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
                        .foregroundStyle(.customBackground)
                    
                    Spacer()
                    
                    Button {
                        // add to bag
                    } label: {
                        Text("Add To Bag")
                            .customStroke(strokeSize: 1.2, strokeColor: .app)
                            .foregroundStyle(Color.customBackground)
                            .background {
                                Capsule()
                                    .fill(Color.customBackground)
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
                    .foregroundStyle(.customBackground)
                
                Text(product.description)
                    .customStroke(strokeSize: 1.2, strokeColor: .app)
                    .foregroundStyle(.customBackground)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .customStroke(strokeSize: 0.15, strokeColor: .app)
                
                Text("Review")
                    .customStroke(strokeSize: 1.6, strokeColor: .app)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.customBackground)
                
                Text(product.description)
                    .customStroke(strokeSize: 1.2, strokeColor: .app)
                    .foregroundStyle(.customBackground)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 30)
        }
        .background(.customBackground)
    }
}

#Preview {
    NavigationView {
        ProductView(id: UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")!)
    }
}
