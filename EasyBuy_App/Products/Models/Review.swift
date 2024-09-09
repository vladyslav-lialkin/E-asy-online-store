//
//  Review.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.09.2024.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: UUID
    let productID: UUID
    let autherName: String
    let createdDate: Date
    let rating: Int
    let comment: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        productID = try container.decode(UUID.self, forKey: .productID)
        autherName = try container.decode(String.self, forKey: .autherName)
        rating = try container.decode(Int.self, forKey: .rating)
        comment = try container.decode(String.self, forKey: .comment)
        
        let dateString = try container.decode(String.self, forKey: .createdDate)
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            createdDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdDate, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
