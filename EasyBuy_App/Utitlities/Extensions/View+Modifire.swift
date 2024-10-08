//
//  View+Modifire.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 09.08.2024.
//

import SwiftUI

extension View {
    func customTextField(color: Color) -> some View {
        self.modifier(TextFieldModifier(color: color))
    }
    
    func showErrorMessega(errorMessage: LocalizedStringKey?) -> some View {
        self.modifier(ShowErrorMessegaModifier(errorMessage: errorMessage))
    }
    
    func showProgressView(isLoading: Bool, background: Bool = true) -> some View {
        self.modifier(ShowProgressViewModifier(isLoading: isLoading, background: background))
    }
    
    func customStroke(strokeSize: CGFloat = 1, strokeColor: Color = .blue) -> some View {
        self.modifier(StrokeModifier(strokeSize: strokeSize, strokeColor: strokeColor))
    }
    
    func capsuleButtonStyle() -> some View {
        self.modifier(CapsuleButtonStyle())
    }
    
    func roundedButton(cornerRadius: CGFloat) -> some View {
        self.modifier(RoundedButtonStyle(cornerRadius: cornerRadius))
    }
}
