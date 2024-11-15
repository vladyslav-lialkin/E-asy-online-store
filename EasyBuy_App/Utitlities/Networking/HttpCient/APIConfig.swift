//
//  Constants.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import Foundation

enum Constants: String {
    case baseURL = "https://server-easybuy-api.fly.dev/"
}

enum Endpoints: String {
    case profile = "profile/"
    case login = "login/"
    case register = "register/"
    case update = "update/"
    case delete = "delete/"
    case changePassword = "change-password/"
    case users = "users/"
    case products = "products/"
    case createPaymentIntent = "create-payment-intent/"
    case favorites = "favorites/"
    case orders = "orders/"
    case cartitems = "cartitems/"
    case reviews = "reviews/"
    case category = "category/"
    case null = ""
}

struct Constant {
    static func startURL(_ endPoints1: Endpoints, _ endPoints2: Endpoints = .null, _ endPoints3: Endpoints = .null) -> String {
        return Constants.baseURL.rawValue + endPoints1.rawValue + endPoints2.rawValue + endPoints3.rawValue
    }
}
