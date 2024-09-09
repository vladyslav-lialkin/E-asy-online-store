//
//  ProductsCoordinatorView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI

struct ProductsCoordinatorView: View {
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        NStack(stack: $coordinator.productsStack) { screens in
            switch screens {
            case .products:
                ProductsView()
            case .categoryProducts(let category):
                CategoryProductsView(category: category)
            case .product(let id):
                ProductView(id: id)
            }
        }
    }
}

#Preview {
    ProductsCoordinatorView()
        .environmentObject(MainTabCoordinator())
}
