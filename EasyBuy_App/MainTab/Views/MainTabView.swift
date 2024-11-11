//
//  MainTabView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var coordinator = MainTabCoordinator()
    
    var body: some View {
        TabView(selection: $coordinator.activeTab) {
            ProductsCoordinatorView()
                .tag(Tab.products)
                .tabItem {
                    Image(systemName: Tab.products.symbolImage)
                    Text("products")
                }
            
            FavoritesCoordinatorView()
                .tag(Tab.favorites)
                .tabItem {
                    Image(systemName: Tab.favorites.symbolImage)
                    Text("favorites")
                }
            
            BagCoordinatorView()
                .tag(Tab.bag)
                .tabItem {
                    Image(systemName: Tab.bag.symbolImage)
                    Text("bag")
                }
            
            ProfileCoordinatorView()
                .tag(Tab.profile)
                .tabItem {
                    Image(systemName: Tab.profile.symbolImage)
                    Text("profile")
                }
        }
        .environmentObject(coordinator)
        .tint(.app)
        .onOpenURL { url in
            let path = url.absoluteString.replacingOccurrences(of: "e-asy://", with: "")
            print(url, path)
            
            if path == "Order" {
                coordinator.activeTab = .profile
                coordinator.profileStack.append(.orders([.all]))
            } else if path == "Favorite" {
                coordinator.activeTab = .favorites
            } else if path == "Bag" {
                coordinator.activeTab = .bag
            } else if path == "Profile" {
                coordinator.activeTab = .profile
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
