//
//  MIMEType.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import Foundation

enum MIMEType {
    case JSON
    case Bearer(String)
    
    var rawValue: String {
        switch self {
        case .JSON:
            return "application/json"
        case .Bearer(let value):
            return "Bearer \(value)"
        }
    }
}
