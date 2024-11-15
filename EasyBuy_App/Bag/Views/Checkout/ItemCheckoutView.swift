//
//  ItemCheckoutView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 14.11.2024.
//

import SwiftUI

struct ItemCheckoutView: View {
    @Binding var bag: Bag
    @ObservedObject var viewModel: CheckoutViewModel

    var body: some View {
        HStack {
            ImageLoader(url: bag.imageUrl)
                .frame(width: 100, height: 68)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.border, lineWidth: 1)
                        .background(Color.customBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, -5)
                        .padding(.vertical, -10)
                }
                .padding(.leading, 17)
            
            VStack {
                Text(bag.name)
                    .customStroke(strokeSize: 1, strokeColor: .app)
                    .font(.callout.bold())
                    .foregroundStyle(.letter)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Text("Price $" + String(format: "%.2f", bag.price))
                    .customStroke(strokeSize: 0.8, strokeColor: .app)
                    .font(.caption)
                    .foregroundStyle(.letter)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    HStack {
                        Button {
                            viewModel.updateBag(for: $bag, .subtractQuantity)
                        } label: {
                            Text("-")
                        }
                        
                        Text("\(bag.quantity)")
                            .foregroundStyle(.app)
                            .frame(width: 30)
                            .lineLimit(1)
                        
                        Button {
                            viewModel.updateBag(for: $bag, .addQuantity)
                        } label: {
                            Text("+")
                        }
                    }
                    .background {
                        Capsule()
                            .stroke(.border, lineWidth: 1)
                            .background(Color.customBackground)
                            .clipShape(Capsule())
                            .padding(.horizontal, -10)
                            .padding(.vertical, -5)
                            .offset(y: 1)
                    }
                    .frame(height: 30)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    
                    Spacer()
                    
                    Button {
                        viewModel.deleteBag(for: bag.id)
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 110)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.border, lineWidth: 1)
                .background(Color.itemBackground)
                .clipShape(.rect(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        CheckoutView()
            .environmentObject(MainTabCoordinator())
    }
    .tint(.app)
}
