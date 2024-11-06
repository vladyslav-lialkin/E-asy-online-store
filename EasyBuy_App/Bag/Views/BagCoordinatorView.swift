//
//  BagCoordinatorView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI

struct BagCoordinatorView: View {
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        NStack(stack: $coordinator.bagStack) { screens in
            switch screens {
            case .bag:
                BagView()
            case .checkout:
                CheckoutView()
            case .product(let id):
                ProductView(id: id)
            }
        }
    }
}

#Preview {
    BagCoordinatorView()
        .environmentObject(MainTabCoordinator())
}
