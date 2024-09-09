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
        GeometryReader {
            if let product = viewModel.product {
                ProductDetailView(
                    viewModel: viewModel,
                    product: product,
                    size: $0.size,
                    safeArea: $0.safeAreaInsets
                )
            } else {
                Text("Product not found")
                    .font(.title2.bold())
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
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
    NavigationView {
        ProductView(id: UUID(uuidString: "2ED280C2-FAD9-44A8-88DF-398CC73C2E60")!)
    }
    .navigationViewStyle(.stack)
}
