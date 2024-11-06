//
//  Bag.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 12.09.2024.
//

import Foundation

enum UpdateBag {
    case addQuantity
    case subtractQuantity
    case isSelected
}

struct Bag: Codable, Equatable, Identifiable {
    let id: UUID
    let userID: UUID
    let productID: UUID
    let name: String
    let price: Double
    let imageUrl: URL
    let createdDate: Date
    var quantity: Int
    let isSelected: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userID = try container.decode(UUID.self, forKey: .userID)
        productID = try container.decode(UUID.self, forKey: .productID)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        quantity = try container.decode(Int.self, forKey: .quantity)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
        
        let dateString = try container.decode(String.self, forKey: .createdDate)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        if let date = dateFormatter.date(from: dateString) {
            createdDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdDate, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

struct CreateBagDTO: Codable {
    let productID: UUID
    let quantity: Int
}

struct UpdateBagDTO: Codable {
    let quantity: Int?
    let isSelected: Bool?
}
