//
//  ProductsView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var coordinator: MainTabCoordinator
    @StateObject private var viewModel = ProductsViewModel()
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var body: some View {
        ScrollView(.vertical) {
            Spacer()
                .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(viewModel.categoriesTitle.enumerated()), id: \.offset) { index, category in
                        Button {
                            coordinator.productsStack.append(.categoryProducts(CategoryEnum.rawValue(index)))
                        } label: {
                            VStack {
                                Spacer()
                                Image(CategoryEnum.rawValue(index))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 85)
                                                                
                                Text(category)
                                    .customStroke(strokeSize: 0.8, strokeColor: .app)
                                    .frame(height: 35 ,alignment: .center)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.letter)
                                    .padding(.bottom, 5)
                            }
                            .frame(width: 105, height: 125)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.border, lineWidth: 1)
                                    .background(Color.itemBackground)
                                    .clipShape(.rect(cornerRadius: 15))
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Text("Discover what's new")
                .font(.title2.bold())
                .padding(.top)
                .padding(.horizontal)
                .frame(width: width, alignment: .leading)
            
            SwipeSlide(items: viewModel.iPhonesImagesUrl) { index, url in
                PageItemView(url: viewModel.iPhonesImagesUrl[index],
                             title: "iPhone 15 pro",
                             price: "$999",
                             id: viewModel.iPhonesID[index] ?? UUID(),
                             coordinator: coordinator)
                .frame(height: 550)
            }
            
            Spacer()
                .frame(height: 50)
        }
        .navigationTitle("Products")
        .background(Color.customBackground)
        .toolbar {
            ToolbarItem {
                Button {
                    coordinator.activeTab = .bag
                } label: {
                    Label("", systemImage: "bag")
                }

            }
        }
        .task {
            await viewModel.startProducts()
        }
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .showProgressView(isLoading: viewModel.isLoading)
    }
}

#Preview {
    NavigationView {
        ProductsView()
            .environmentObject(MainTabCoordinator())
    }
}
