//
//  ProductDeteilView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        GeometryReader { reader in
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    if let product = viewModel.product {
                        ProductImageView(product: product, safeArea: reader.safeAreaInsets)
                        
                        VStack {
                            ProductSummaryView(viewModel: viewModel, product: product)
                            
                            ProductReviewView(viewModel: viewModel, product: product, proxy: proxy)
                        }
                        .padding(.horizontal, 30)
                    } else {
                        Text("Product not found")
                            .font(.title2.bold())
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .position(CGPoint(x: reader.size.width/2, y: reader.size.height/2))
                    }
                }
                .refreshable {
                    await viewModel.startProduct()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(.customBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                }
            }
        }
        .task {
            await viewModel.startProduct()
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
    
    init(id: UUID) {
        viewModel = ProductViewModel(productID: id)
    }
}

#Preview {
    NavigationView {
        ProductView(id: UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")!)
    }
    .navigationViewStyle(.stack)
}
