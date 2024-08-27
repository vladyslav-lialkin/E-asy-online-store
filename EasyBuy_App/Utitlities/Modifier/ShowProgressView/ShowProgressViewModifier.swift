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
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    LettersView()
                }
            }
            .animation(.easeInOut, value: isLoading)
    }
}


#Preview {
    Color.customBackground
        .ignoresSafeArea()
        .modifier(ShowProgressViewModifier(isLoading: true))
}