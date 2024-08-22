//
//  FavoritesStack.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import Foundation

enum FavoritesStack: CustomStringConvertible {
    case favorites
    case product(UUID)

    var description: String {
        switch self {
        case .favorites:
            return "Favorites"
        case .product(let id):
            return "Product:\(id.uuidString)"
        }
    }

    init?(rawValue: String) {
        if rawValue == "Favorites" {
            self = .favorites
        } else if rawValue.starts(with: "Product:") {
            let uuidString = String(rawValue.dropFirst("Product:".count))
            if let uuid = UUID(uuidString: uuidString) {
                self = .product(uuid)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
