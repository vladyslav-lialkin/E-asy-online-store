//
//  LaunchScreenView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 04.11.2024.
//

import SwiftUI

struct LaunchScreenView<Content: View>: View {
    @State private var isFirstLaunch: Bool = true
    @State private var size = 0.8
    @State private var opacity = 0.4
    
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .overlay {
                if isFirstLaunch {
                    ZStack {
                        Color.customBackground
                            .ignoresSafeArea()
                        VStack {
                            Image("E-ASY")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .scaleEffect(size)
                        }
                        .opacity(opacity)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                size = 1.2
                                opacity = 1.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.isFirstLaunch = false
                                }
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    LaunchScreenView {
        EmptyView()
    }
}
