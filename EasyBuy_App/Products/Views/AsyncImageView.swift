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
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                    Text("Error")
                        .font(.title.weight(.bold))
                }
                .foregroundColor(.red)
            @unknown default:
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                    Text("Error")
                        .font(.title.weight(.bold))
                }
                .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    VStack {
        AsyncImageView(url: nil)
    }
}
