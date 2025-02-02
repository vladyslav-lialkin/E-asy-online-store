//
//  BagBottomBarView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 01.10.2024.
//

import SwiftUI

struct BagBottomBarView: View {
    @ObservedObject var viewModel: BagViewModel
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        HStack {
            Button {
                viewModel.updateAllSelected()
            } label: {
                Image(
                    systemName: viewModel.bags.allSatisfy(\.isSelected) ? "checkmark.circle.fill" : "circle"
                )
                .font(.title2)
            }
            .padding(.leading)
            
            Text("All")
                .customStroke(strokeSize: 1.5, strokeColor: .app)
                .foregroundStyle(.letter)
            
            Spacer()
            
            Text(String(format: "%.2f",
                viewModel.bags
                    .filter { $0.isSelected }
                    .reduce(0.00) { $0 + ($1.price * Double($1.quantity)) }
            ))
            .customStroke(strokeSize: 1.5, strokeColor: .app)
            .foregroundStyle(.letter)
            .padding(.horizontal)
            .animation(.none, value: viewModel.bags)
            
            Button {
                coordinator.bagStack.append(.checkout)
            } label: {
                Text("Chackout (\(viewModel.bags.filter { $0.isSelected }.count))")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.letter)
                    .background {
                        Capsule()
                            .stroke(Color.border, lineWidth: 1)
                            .background(Color.app)
                            .clipShape(Capsule())
                            .padding(.vertical, -7)
                            .padding(.horizontal, -12)
                    }
            }
            .disabled(viewModel.bags.filter(\.isSelected).count == 0)
            .padding(.trailing, 28)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.border, lineWidth: 1)
                .background(Color.itemBackground)
                .clipShape(.rect(cornerRadius: 10))
        }
        .padding(.horizontal, 5)
        .padding(.bottom)
    }
}

#Preview {
    BagBottomBarView(viewModel: BagViewModel())
        .environmentObject(MainTabCoordinator())
}
