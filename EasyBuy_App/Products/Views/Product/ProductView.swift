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
            if let product = viewModel.product {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        ProductImageView(product: product, safeArea: reader.safeAreaInsets)
                        
                        VStack {
                            ProductSummaryView(viewModel: viewModel, product: product)
                            
                            ProductReviewView(viewModel: viewModel, product: product, proxy: proxy)
                        }
                        .padding(.horizontal, 30)
                    }
                    .refreshable {
                        viewModel.startProduct()
                    }
                }
            } else {
                Text("Product not found")
                    .font(.title2.bold())
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(.customBackground)
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .navigationBarTitleDisplayMode(.inline)
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
        viewModel = ProductViewModel(productID: id)
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            ProductView(id: UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")!)
        }
        .navigationViewStyle(.stack)
    } else {
        NavigationView {
            ProductView(id: UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")!)
        }
        .navigationViewStyle(.stack)
    }
}
