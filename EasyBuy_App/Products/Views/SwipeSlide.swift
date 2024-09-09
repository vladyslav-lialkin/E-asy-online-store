//
//  SwipeSlide.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI

struct SwipeSlide<Item, Content: View>: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    let size = UIScreen.main.bounds.size
    let items: [Item]
    let content: (Int, Item) -> Content

    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    content(index, item)
                        .opacity(currentIndex == index ? 1.0 : 0.5)
                        .scaleEffect(currentIndex == index ? 1 : 0.8)
                        .offset(x: CGFloat(index - currentIndex) * size.width + dragOffset)
                        .animation(.spring(), value: dragOffset)
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                currentIndex = min(items.count - 1, currentIndex + 1)
                            }
                        }
                    }
            )
        }
    }
}

#Preview {
    SwipeSlide(items: Array(0...5)) {_, item  in
        Text("Item \(item)")
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(Color.blue)
            .cornerRadius(10)
            .padding()
    }
}
