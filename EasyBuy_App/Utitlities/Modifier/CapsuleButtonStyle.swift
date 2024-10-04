//
//  CapsuleButtonStyle.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 03.10.2024.
//

import SwiftUI

struct CapsuleButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .stroke(Color.border, lineWidth: 1)
                    .background(Color.itemBackground)
                    .clipShape(Capsule())
            }
    }
}
