//
//  FavoritesCoordinatorView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI

struct FavoritesCoordinatorView: View {
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        NStack(stack: $coordinator.favouritesStack) { screens in
            switch screens {
            case .favorites:
                FavoritesView()
            case .product(_):
                EmptyView()
            }
        }
    }
}

#Preview {
    FavoritesCoordinatorView()
}
