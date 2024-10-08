//
//  RoundedButtonStyle.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import SwiftUI

struct RoundedButtonStyle: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.border, lineWidth: 1)
                    .background(Color.itemBackground)
                    .clipShape(.rect(cornerRadius: cornerRadius))
            }
    }
}
