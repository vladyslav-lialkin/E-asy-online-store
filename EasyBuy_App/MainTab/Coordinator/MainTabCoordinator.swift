//
//  MainTabCoordinator.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

final class MainTabCoordinator: ObservableObject {
    @Published var activeTab: Tab = .products
    @Published var productsStack: [ProductsStack] = [.products]
    @Published var favouritesStack: [FavoritesStack] = [.favorites]
    @Published var bagStack: [BagStack] = [.bag]
    @Published var profileStack: [ProfileStack] = [.profile]
    
    deinit {
        print("deinit: MainTabCoordinator")
    }
}
