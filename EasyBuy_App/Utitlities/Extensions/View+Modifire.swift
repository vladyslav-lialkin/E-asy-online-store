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
    
    func showProgressView(isLoading: Bool) -> some View {
        self.modifier(ShowProgressViewModifier(isLoading: isLoading))
    }
    
    func customStroke(strokeSize: CGFloat = 1, strokeColor: Color = .blue) -> some View {
        self.modifier(StrokeModifier(strokeSize: strokeSize, strokeColor: strokeColor))
    }
}
