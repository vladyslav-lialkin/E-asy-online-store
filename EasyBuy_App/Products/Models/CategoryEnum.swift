//
//  CategoryEnum.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import Foundation

enum CategoryEnum: String, CaseIterable, Identifiable {
    case iPhone = "iPhone"
    case AppleWatch = "Apple_Watch"
    case iPad = "iPad"
    case Mac = "Mac"
    case AppleVisionPro = "Apple_Vision_Pro"
    case AirPods = "AirPods"
    case AppleTV4K = "Apple_TV_4K"
    case HomePod = "HomePod"
    case AirTag = "AirTag"
    
    var id: String { self.rawValue }
    
    static func rawValue(_ intValue: Int) -> String {
        let result = switch intValue {
        case 0: self.iPhone.rawValue
        case 1: self.AppleWatch.rawValue
        case 2: self.iPad.rawValue
        case 3: self.Mac.rawValue
        case 4: self.AppleVisionPro.rawValue
        case 5: self.AirPods.rawValue
        case 6: self.AppleTV4K.rawValue
        case 7: self.HomePod.rawValue
        case 8: self.AirTag.rawValue
        default:
            self.AirTag.rawValue
        }
        
        return result.replacingOccurrences(of: "_", with: " ")
    }
}
