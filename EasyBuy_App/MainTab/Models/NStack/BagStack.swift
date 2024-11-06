//
//  BagStack.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import Foundation

enum BagStack: CustomStringConvertible {
    case bag
    case checkout
    case product(UUID)

    var description: String {
        switch self {
        case .bag:
            return "Bag"
        case .checkout:
            return "Checkout"
        case .product(let id):
            return "Product:\(id.uuidString)"
        }
    }

    init?(rawValue: String) {
        if rawValue == "Bag" {
            self = .bag
        } else if rawValue == "Checkout" {
            self = .checkout
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
