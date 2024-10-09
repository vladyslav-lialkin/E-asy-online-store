//
//  BagItem.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.09.2024.
//

import SwiftUI

struct BagItem: View {
    @ObservedObject var viewModel: BagViewModel
    let coordinator: MainTabCoordinator
    let bag: Bag
    
    var body: some View {
        Button {
            coordinator.bagStack.append(.product(bag.productID))
        } label: {
            HStack {
                Button {
                    Task {
                        await viewModel.updateBag(for: bag, .isSelected)
                        await viewModel.reloadData()
                    }
                } label: {
                    Image(
                        systemName: bag.isSelected ? "checkmark.circle.fill" : "circle"
                    )
                    .font(.title2)
                }
                .padding(.leading, 5)
                
                AsyncImageView(url: bag.imageUrl)
                    .frame(width: 100, height: 68)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.border, lineWidth: 1)
                            .background(Color.customBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, -5)
                            .padding(.vertical, -10)
                    }
                
                VStack {
                    Text(bag.name)
                        .customStroke(strokeSize: 1, strokeColor: .app)
                        .font(.callout.bold())
                        .foregroundStyle(.letter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    HStack {
                        Text("Price $" + String(format: "%.2f", bag.price))
                            .customStroke(strokeSize: 0.8, strokeColor: .app)
                            .font(.caption)
                            .foregroundStyle(.letter)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack {
                            Button {
                                Task {
                                    await viewModel.updateBag(for: bag, .subtractQuantity)
                                    await viewModel.reloadData()
                                }
                            } label: {
                                Text("-")
                            }
                            
                            Text("\(bag.quantity)")
                                .frame(width: 30)
                                .lineLimit(1)
                            
                            Button {
                                Task {
                                    await viewModel.updateBag(for: bag, .addQuantity)
                                    await viewModel.reloadData()
                                }
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
                        .padding(.trailing)
                    }
                }
            }
            .frame(height: 100)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.border, lineWidth: 1)
                    .background(Color.itemBackground)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationView {
        BagView()
            .environmentObject(MainTabCoordinator())
    }
    .navigationViewStyle(.stack)
}
