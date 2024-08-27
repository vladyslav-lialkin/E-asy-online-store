//
//  Letters.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 27.08.2024.
//

import SwiftUI

struct LetterE: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.maxY * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.midY * 0.9))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY * 0.9))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY * 1.1))
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.midY * 1.1))
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.maxY * 0.9))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.9))
        path.closeSubpath()

        return path
    }
}

struct MinusSign: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX * 0.1, y: rect.midY * 0.9))
        path.addLine(to: CGPoint(x: rect.maxX * 0.9, y: rect.midY * 0.9))
        path.addLine(to: CGPoint(x: rect.maxX * 0.9, y: rect.midY * 1.1))
        path.addLine(to: CGPoint(x: rect.maxX * 0.1, y: rect.midY * 1.1))
        path.closeSubpath()

        return path
    }
}

struct LetterA: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX * 0.9, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX * 1.1, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.85, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.9))
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.maxY * 0.9))
        path.addLine(to: CGPoint(x: rect.maxX * 0.15, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX * 0.2, y: rect.maxY))
        path.closeSubpath()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY * 0.2))
        path.addLine(to: CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 0.8))
        path.addLine(to: CGPoint(x: rect.maxX * 0.25, y: rect.maxY * 0.8))
        path.closeSubpath()

        return path
    }
}

struct LetterS: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.15))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.05))
        
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY * 0.4),
                          control: CGPoint(x: rect.midX * 0.2, y: rect.maxY * -0.1))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX * 0.5, y: rect.maxY * 0.5),
                          control: CGPoint(x: rect.minX, y: rect.midY * 0.85))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY * 0.92),
                          control: CGPoint(x: rect.maxX * 1.1, y: rect.maxY * 0.75))
        
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY * 0.89),
                          control: CGPoint(x: rect.midX * 0.6, y: rect.maxY * 0.97))

        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.7),
                      control1: CGPoint(x: rect.midX * 0.9, y: rect.maxY * 1.1),
                      control2: CGPoint(x: rect.maxX, y: rect.maxY))

        path.addQuadCurve(to: CGPoint(x: rect.maxX * 0.6, y: rect.midY * 0.83),
                          control: CGPoint(x: rect.maxX * 0.95, y: rect.midY))
        
        path.addCurve(to: CGPoint(x: rect.maxX * 0.6, y: rect.midY * 0.25),
                      control1: CGPoint(x: rect.maxX * 0.1, y: rect.midY * 0.65),
                      control2: CGPoint(x: rect.maxX * 0.1, y: rect.midY * 0.1))

        path.closeSubpath()

        return path
    }
}

struct LetterY: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.15, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.5, y: rect.maxY * 0.4))
        path.addLine(to: CGPoint(x: rect.maxX * 0.85, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.57, y: rect.maxY * 0.52))
        path.addLine(to: CGPoint(x: rect.maxX * 0.57, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.43, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.43, y: rect.maxY * 0.52))

        path.closeSubpath()

        return path
    }
}
