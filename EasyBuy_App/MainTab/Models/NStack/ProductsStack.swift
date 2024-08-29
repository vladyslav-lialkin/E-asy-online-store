//
//  ProductsStack.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import Foundation

enum ProductsStack: CustomStringConvertible {
    case products
    case categoryProducts(String)
    case product(UUID)

    var description: String {
        switch self {
        case .products:
            return "Products"
        case .categoryProducts(let category):
            return "Category:\(category)"
        case .product(let id):
            return "Product:\(id.uuidString)"
        }
    }

    init?(rawValue: String) {
        if rawValue == "Products" {
            self = .products
        } else if rawValue.starts(with: "Category:") {
            let category = String(rawValue.dropFirst("Category:".count))
            self = .categoryProducts(category)
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

