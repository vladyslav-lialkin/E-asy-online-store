//
//  Tab.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

enum Tab: String {
    case products = "Products"
    case favorites = "Favorites"
    case bag = "Bag"
    case profile = "Profile"
    
    var symbolImage: String {
        switch self {
        case .products: return "macbook.and.iphone"
        case .favorites: return "heart"
        case .bag: return "bag"
        case .profile: return "person"
        }
    }
}
