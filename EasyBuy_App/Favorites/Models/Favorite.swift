//
//  Favorite.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.09.2024.
//

import Foundation

struct Favorite: Codable {
    var id: UUID
    var userID: UUID
    var productID: UUID
    var createdDate: Date
}
