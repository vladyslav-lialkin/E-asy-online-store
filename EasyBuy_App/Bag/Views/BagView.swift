//
//  BagView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct BagView: View {
    @StateObject private var viewModel = BagViewModel()
    @EnvironmentObject var coordinator: MainTabCoordinator
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            if !viewModel.bags.isEmpty {
                VStack(spacing: 0) {
                    ScrollView {
                        Spacer()
                            .padding(.top)
                        
                        ForEach(viewModel.bags) { bag in
                            BagItem(viewModel: viewModel,
                                    coordinator: coordinator,
                                    bag: bag)
                        }
                        
                        Spacer()
                            .padding(.bottom)
                    }
                    .refreshable {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        await viewModel.startBags()
                    }

                    BagBottomBarView(viewModel: viewModel)
                }
            } else {
                VStack {
                    Image(systemName: "bag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .foregroundStyle(.app)
                        .opacity(0.8)
                    
                    Text("Your bag is empty")
                        .font(.title2.bold())
                        .foregroundStyle(.letter)
                        .customStroke(strokeSize: 2, strokeColor: .app)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.bags)
        .navigationTitle("Bag")
        .toolbar {
            Button {
                viewModel.deleteAllSelected()
            } label: {
                Image(systemName: "trash")
            }
        }
        .task {
            await viewModel.startBags()
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
}

#Preview {
    NavigationView {
        BagView()
            .environmentObject(MainTabCoordinator())
    }
    .navigationViewStyle(.stack)
    .tint(.app)
}
