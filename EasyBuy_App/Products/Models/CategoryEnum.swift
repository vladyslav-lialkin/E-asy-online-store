//
//  CategoryEnum.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import Foundation

enum CategoryEnum: String, CaseIterable, Identifiable {
    case Mac
    case iPad
    case iPhone
    case Watch
    case Vision
    case AirPods
    case TVAndHome
    case Accessories
    
    var id: String { self.rawValue }
}
