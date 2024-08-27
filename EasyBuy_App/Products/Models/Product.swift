//
//  Product.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let stockQuantity: Int
    let category: CategoryEnum.RawValue
    let imagesUrl: [URL]
    let createdAt: Date
    var imagesData = [Data]()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case stockQuantity
        case category
        case imagesUrl
        case createdAt
        case imagesData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        stockQuantity = try container.decode(Int.self, forKey: .stockQuantity)
        category = try container.decode(CategoryEnum.RawValue.self, forKey: .category)
        imagesUrl = try container.decode([URL].self, forKey: .imagesUrl)
        
        let dateString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            createdAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

//[
//    {
//        "updatedAt": "2024-08-23T16:09:36Z",
//        "stockQuantity": 2,
//        "createdAt": "2024-08-23T16:09:36Z",
//        "name": "MacBook Air 2022 512 mamory",
//        "price": 899.99,
//        "id": "79AE0D38-1FBE-4237-BEC9-1043BD55DCCF",
//        "imagesUrl": [
//            "https://img.jabko.ua/image/cache/catalog/products/2020/11/111144/2-2-1397x1397.jpg.webp"
//        ],
//        "status": "published",
//        "category": "Mac",
//        "author": "Optional(\"Vladyslav\") Optional(\"Lialkin\")",
//        "description": "Cool Mac, buy me"
//    }
//]
