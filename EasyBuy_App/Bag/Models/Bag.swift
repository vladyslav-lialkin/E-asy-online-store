//
//  Bag.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 12.09.2024.
//

import Foundation

struct Bag: Codable, Identifiable {
    var id: UUID
    var userID: UUID
    var productID: UUID
    var createdDate: Date
    var quantity: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userID = try container.decode(UUID.self, forKey: .userID)
        productID = try container.decode(UUID.self, forKey: .productID)
        quantity = try container.decode(Int.self, forKey: .quantity)

        let dateString = try container.decode(String.self, forKey: .createdDate)
        if let date = ISO8601DateFormatter().date(from: dateString) {
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
