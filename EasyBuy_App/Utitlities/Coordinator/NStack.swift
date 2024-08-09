//
//  NStack.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.08.2024.
//

import SwiftUI

struct NStack<Screen, ScreenView: View>: View {
    @Binding var stack: [Screen]
    @ViewBuilder var buildView: (Screen) -> ScreenView
    
    var body: some View {
        NavigationView {
            stack
                .enumerated()
                .reversed()
                .reduce(NavigationNode<Screen, ScreenView>.end) { pushedNode, new in
                    let (index, screen) = new
                    return NavigationNode<Screen, ScreenView>.view(
                        buildView(screen),
                        pushing: pushedNode,
                        stack: $stack,
                        index: index
                    )
                }
        }
        .navigationViewStyle(.stack)
    }
}


indirect enum NavigationNode<Screen, ScreenView: View>: View {
    case view(ScreenView, pushing: NavigationNode<Screen, ScreenView>, stack: Binding<[Screen]>, index: Int)
    case end
    
    var body: some View {
        if case .view(let view, let pushedNode, let stack, let index) = self {
            view.background(
                NavigationLink(
                    destination: pushedNode,
                    isActive: Binding(
                        get: {
                            return stack.wrappedValue.count > index + 1
                        },
                        set: { isPushed in
                            guard !isPushed else { return }
                            if stack.wrappedValue.count > index + 1 {
                                print("was stack count:", stack.count)
                                stack.wrappedValue.removeLast()
                                print("stack.wrappedValue.removeLast()")
                                print("stack count:", stack.count)
                            }
                        }),
                    label: EmptyView.init
                ).hidden()
            )
        } else {
            EmptyView()
        }
    }
}
