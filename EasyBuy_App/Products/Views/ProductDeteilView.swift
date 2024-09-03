//
//  ProductDeteilView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import SwiftUI

struct ProductDeteilView: View {
    @ObservedObject var viewModel: ProductDeteilViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let safeArea = geometry.safeAreaInsets
            
            ScrollView(showsIndicators: false) {
                ZStack {
                    Rectangle()
                        .fill(.customBackground)
                        .padding(.top, -(safeArea.top))
                        .padding(.bottom, -50)
                    
                    AsyncImage(url: viewModel.imagesURL.first) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .scaleEffect(1.2)
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
                    }.frame(height: 350)
                }
                
                Spacer()
                    .frame(height: 25)
                
                VStack {
                    Spacer()
                        .frame(height: 15)
                    
                    HStack {
                        Text(viewModel.title)
                            .customStroke(strokeSize: 2, strokeColor: .app)
                            .font(.title.bold())
                            .foregroundStyle(.customBackground)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                        
                        Button {
                            viewModel.favorite.toggle()
                        } label: {
                            Image(systemName: viewModel.favorite == true ? "heart.fill" : "heart")
                                .font(.title.bold())
                                .foregroundStyle(.app)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    HStack {
                        Text("Price " + viewModel.price)
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
                    }
                    .frame(height: 60)
                    .background(Color.banerBottom)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                        .frame(height: 15)
                }
                .background(.banerBottom)
                .clipShape(.rect(cornerRadius: 20))
            }
        }
        .background(.banerBottom)
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                }
            }
        }
    }
    
    init(id: UUID) {
        viewModel = ProductDeteilViewModel(productID: id)
    }
}

#Preview {
    NavigationView {
        ProductDeteilView(id: UUID(uuidString: "2ED280C2-FAD9-44A8-88DF-398CC73C2E60")!)
    }
}
