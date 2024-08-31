//
//  Color+Ext.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 10.08.2024.
//

import SwiftUI

extension Color {
    static var lable = Color(uiColor: UIColor.label)
}

extension ShapeStyle where Self == Color {
    static var lable: Color {
        Color.lable
    }
}
