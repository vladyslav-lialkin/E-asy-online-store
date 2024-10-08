//
//  StatusOrderEnum.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 01.10.2024.
//

import Foundation
import SwiftUICore

enum StatusOrderEnum: String {
    case new
    case processing
    case shipped
    case delivered
    case canceled
    case returned
    
    // for see all
    case all = "All"
    
    var color: Color {
        switch self {
        case .new:
            return Color.green
        case .processing:
            return Color.orange
        case .shipped:
            return Color.blue
        case .delivered:
            return Color.purple
        case .canceled:
            return Color.red
        case .returned:
            return Color.gray
        case .all:
            return Color.clear
        }
    }
}
