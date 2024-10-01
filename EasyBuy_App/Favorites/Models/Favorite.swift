//
//  Favorite.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import Foundation

struct Favorite: Codable, Equatable, Identifiable {
    let id: UUID
    let userID: UUID
    let productID: UUID
    let name: String
    let price: Double
    let imageUrl: URL
    let createdDate: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userID = try container.decode(UUID.self, forKey: .userID)
        productID = try container.decode(UUID.self, forKey: .productID)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        
        
        let dateString = try container.decode(String.self, forKey: .createdDate)
        if let date = ISO8601DateFormatter().date(from: dateString) {
            createdDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdDate, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

struct CreateFavoriteDTO: Codable {
    let productID: UUID
}
