//
//  PaymentIntent.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 13.11.2024.
//

import Foundation

struct PaymentIntentRequest: Codable {
    var amount: Int
}

struct PaymentIntentResponse: Codable {
    var clientSecret: String
}
