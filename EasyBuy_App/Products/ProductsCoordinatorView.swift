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
            case .product(_):
                EmptyView()
            }
        }
    }
}

#Preview {
    ProductsCoordinatorView()
}
