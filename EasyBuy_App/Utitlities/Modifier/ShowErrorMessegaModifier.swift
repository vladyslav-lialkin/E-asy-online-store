//
//  ShowErrorMessegaModifier.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 23.08.2024.
//

import SwiftUI

struct ShowErrorMessegaModifier: ViewModifier {
    var errorMessage: LocalizedStringKey?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if let message = errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(uiColor: .systemGray2))
                                .opacity(0.9)
                        }
                        .frame(width: 230)
                }
            }
    }
}
