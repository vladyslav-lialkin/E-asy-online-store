//
//  PageTabView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI

struct PageTabView<Content: View>: View {
    let content: () -> Content

    var body: some View {
        TabView {
            content()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    PageTabView {
        ForEach(0..<5) { index in
            Text("Item \(index)")
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
        }
    }
}
