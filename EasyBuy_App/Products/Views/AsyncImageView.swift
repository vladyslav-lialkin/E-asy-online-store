//
//  AsyncImageView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 06.09.2024.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Spacer()
                ProgressView()
                    .scaleEffect(1.2)
                Spacer()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Text("❌")
                    .font(.title)
                    .foregroundColor(.red)
            @unknown default:
                Text("❌")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    AsyncImageView(url: nil)
}
