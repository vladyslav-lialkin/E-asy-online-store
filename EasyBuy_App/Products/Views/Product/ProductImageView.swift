//
//  ProductImageView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 11.09.2024.
//

import SwiftUI

struct ProductImageView: View {
    let product: Product
    let safeArea: EdgeInsets
    
    let size = UIScreen.main.bounds.size
    let height = UIScreen.main.bounds.size.height * 0.32
    
    var body: some View {
        VStack {
            GeometryReader {
                let minY = $0.frame(in: .global).minY
                let minusY = -minY
                let size = $0.size
                let adjusted = minY - safeArea.top > 0 ? minY - safeArea.top : 0
                
                SwipeSlide(items: product.imagesUrl) {_, url in
                    AsyncImageView(url: url)
                        .frame(maxWidth: .infinity)
                        .frame(height: size.height)
                }
                .offset(y: (minusY + safeArea.top) + adjusted)
                .overlay(alignment: .bottom) {
                    GeometryReader {_ in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.productBaner)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.border, lineWidth: 1)
                        }
                        .clipShape(.rect(cornerRadius: 20))
                        .offset(y: height + 35)
                        .frame(height: self.size.height + minusY)
                    }
                }
            }
            .frame(height: height)
        }
    }
}

#Preview {
    NavigationView {
        ProductView(id: UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")!)
    }
}
