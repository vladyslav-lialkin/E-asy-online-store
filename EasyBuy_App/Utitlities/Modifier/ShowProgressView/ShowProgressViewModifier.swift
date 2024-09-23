//
//  ShowProgressViewModifier.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 24.08.2024.
//

import SwiftUI

struct ShowProgressViewModifier: ViewModifier {
    var isLoading: Bool
    let background: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    LettersView(background: background)
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
