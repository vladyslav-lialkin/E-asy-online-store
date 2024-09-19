//
//  ShowProgressViewModifier.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 24.08.2024.
//

import SwiftUI

struct ShowProgressViewModifier: ViewModifier {
    @State private var isMovingAround = false
    
    var isLoading: Bool
    let background: Bool
    
    func body(content: Content) -> some View {
        VStack {
            if isLoading {
                LettersView(background: background)
            } else {
                content
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}


#Preview {
    Color.customBackground
        .ignoresSafeArea()
        .modifier(ShowProgressViewModifier(isLoading: true, background: true))
}
