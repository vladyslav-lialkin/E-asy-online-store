//
//  View+Modifire.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 09.08.2024.
//

import SwiftUI

extension View {
    func customBackButton() -> some View {
        self.modifier(BackButtonModifier())
    }
    
    func customTextField(color: Color) -> some View {
        self.modifier(TextFieldModifier(color: color))
    }
}
