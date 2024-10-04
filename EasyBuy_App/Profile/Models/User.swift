//
//  User.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 02.10.2024.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID
    var name: String?
    var lastname: String?
    var username: String
    var email: String
    var city: String?
    var postalcode: String?
    var address: String?
    var phoneNumber: String?
    var country: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        postalcode = try container.decodeIfPresent(String.self, forKey: .postalcode)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        country = try container.decodeIfPresent(String.self, forKey: .country)

        let createdDateString = try container.decode(String.self, forKey: .createdAt)
        let updatedDateString = try container.decode(String.self, forKey: .updatedAt)
        let dateFormatter = ISO8601DateFormatter()
        
        if let createdDate = dateFormatter.date(from: createdDateString) {
            createdAt = createdDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Created date string does not match format expected by formatter.")
        }

        if let updatedDate = dateFormatter.date(from: updatedDateString) {
            updatedAt = updatedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .updatedAt, in: container, debugDescription: "Updated date string does not match format expected by formatter.")
        }
    }
}
