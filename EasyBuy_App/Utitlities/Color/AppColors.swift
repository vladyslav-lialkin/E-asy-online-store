//
//  AppColors.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.08.2024.
//

import SwiftUI

struct AppColors {
    static let gradient = LinearGradient(
        colors: [.red, .orange, .orange, .red],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static var adaptiveGradient: some ShapeStyle {
        if #available(iOS 16.0, *) {
            return LinearGradient(
                colors: [.red, .orange, .orange, .red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return Color.red
        }
    }
}
