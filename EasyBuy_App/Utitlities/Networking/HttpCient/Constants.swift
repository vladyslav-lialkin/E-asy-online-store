//
//  Constants.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import Foundation

enum Constants: String {
    case baseURL = "https://server-easybuy-api.fly.dev"
}

enum Endpoints: String {
    case profile = "/profile"
    case login = "/login"
    case register = "/register"
    case update = "/update"
    case delete = "/delete"
    case users = "/users"
    case products = "/products"
    case favorites = "/favorites"
    case orders = "/orders"
    case cartitems = "/cartitems"
    case reviews = "/reviews"
}
