//
//  Order.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 01.10.2024.
//

import Foundation

struct Order: Codable {
    let id: UUID
    let userID: UUID
    let productID: UUID
    let name: String
    let imageUrl: URL
    let orderDate: Date
    let statusOrder: StatusOrderEnum.RawValue
    let quantity: Int
    let price: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userID = try container.decode(UUID.self, forKey: .userID)
        productID = try container.decode(UUID.self, forKey: .productID)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        statusOrder = try container.decode(StatusOrderEnum.RawValue.self, forKey: .statusOrder)
        quantity = try container.decode(Int.self, forKey: .quantity)
        price = try container.decode(Double.self, forKey: .price)
        
        let dateString = try container.decode(String.self, forKey: .orderDate)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        if let date = dateFormatter.date(from: dateString) {
            orderDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .orderDate, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

struct CreateOrderDTO: Codable {
    let productID: UUID
    let quantity: Int
}
