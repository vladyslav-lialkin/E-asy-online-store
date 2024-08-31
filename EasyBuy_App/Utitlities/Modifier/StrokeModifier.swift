//
//  StrokeModifier.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 31.08.2024.
//

import SwiftUI

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundStyle(strokeColor)
                    .mask({
                        outline(content: content)
                    })
            )
    }
    
    func outline(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: CGPoint(x: size.width / 2, y: size.height / 2))
                }
            }
        } symbols: {
            content.tag(id)
                .blur(radius: strokeSize)
        }
    }
}
