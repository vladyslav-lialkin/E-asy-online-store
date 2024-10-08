//
//  LettersView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 27.08.2024.
//

import SwiftUI

struct LettersView: View {
    @State private var isMovingAround = false
    let background: Bool
    
    var body: some View {
        ZStack {
            if background {
                Color.customBackground.ignoresSafeArea()
            } else {
                Color.customBackground
                    .frame(width: 125, height: 60)
            }
            
            HStack {
                LetterE()
                    .stroke(style: StrokeStyle(lineWidth: 2.7,
                                               lineCap: .round,
                                               lineJoin: .round,
                                               dash: [10, 6],
                                               dashPhase: isMovingAround ? -220 : 220))
                    .frame(width: 15, height: 30)
                
                MinusSign()
                    .stroke(style: StrokeStyle(lineWidth: 2.7,
                                               lineCap: .round,
                                               lineJoin: .round,
                                               dash: [10, 6],
                                               dashPhase: isMovingAround ? -220 : 220))
                    .frame(width: 10, height: 30)
                    .padding(.leading, -4)

                LetterA()
                    .stroke(style: StrokeStyle(lineWidth: 2.7,
                                               lineCap: .round,
                                               lineJoin: .round,
                                               dash: [10, 6],
                                               dashPhase: isMovingAround ? -220 : 220))
                    .frame(width: 22.5, height: 30)
                    .padding(.leading, -9)

                LetterS()
                    .stroke(style: StrokeStyle(lineWidth: 2.7,
                                               lineCap: .round,
                                               lineJoin: .round,
                                               dash: [10, 6],
                                               dashPhase: isMovingAround ? -220 : 220))
                    .frame(width: 15, height: 30)
                    .padding(.leading, -3.5)
                
                LetterY()
                    .stroke(style: StrokeStyle(lineWidth: 2.6,
                                               lineCap: .round,
                                               lineJoin: .round,
                                               dash: [10, 6],
                                               dashPhase: isMovingAround ? -220 : 220))
                    .frame(width: 22.5, height: 30)
                    .padding(.leading, -6.5)
            }
            
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: StrokeStyle(lineWidth: 2.7,
                                           lineCap: .round,
                                           lineJoin: .round,
                                           dash: [10, 6],
                                           dashPhase: isMovingAround ? -220 : 220))
            
                .frame(width: 115, height: 50)
            
            RoundedRectangle(cornerRadius: 18)
                .stroke(style: StrokeStyle(lineWidth: 2.7,
                                           lineCap: .round,
                                           lineJoin: .round,
                                           dash: [10, 6],
                                           dashPhase: isMovingAround ? 220 : -220))
            
                .frame(width: 121.5, height: 57)
        }
        .foregroundStyle(.app)
        .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: isMovingAround)
        .onAppear {
            isMovingAround = true
        }
    }
}

#Preview {
    LettersView(background: true)
}
