//
//  TextFieldModifier.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 10.08.2024.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.leading)
            .padding(.trailing, 5)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 0.7)
            }
            .padding(.horizontal)
    }
}
