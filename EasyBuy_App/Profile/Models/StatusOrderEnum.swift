//
//  StatusOrderEnum.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 01.10.2024.
//

import Foundation

enum StatusOrderEnum: String {
    case new
    case processing
    case shipped
    case delivered
    case canceled
    case returned
    
    // for see all
    case all = ""
}
