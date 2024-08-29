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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(viewModel.categoriesTitle.enumerated()), id: \.offset) { index, category in
                        Button {
                            coordinator.productsStack.append(.categoryProducts(CategoryEnum.rawValue(index)))
                        } label: {
                            VStack {
                                Spacer()
                                Spacer()
                                Image(CategoryEnum.rawValue(index))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 85)
                                                                
                                Text(category)
                                    .frame(height: 35 ,alignment: .center)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.lable)
                                    .padding(.bottom, 5)
                            }
                            .frame(width: 105, height: 125)
                            .background(Color.itemBackground)
                            .clipShape(.rect(cornerRadius: 15))
                        }
                    }
                }
                .padding(.top)
                .padding(.horizontal)
            }
            
            Text("Discover what's new")
                .font(.title2.bold())
                .padding(.top)
                .padding(.horizontal)
                .frame(width: width, alignment: .leading)
            
            PageTabView {
                ForEach(viewModel.iPhonesImagesUrl, id: \.self) { url in
                    PageItemView(url: url,
                             title: "iPhone 15 pro",
                             price: "$999",
                             id: UUID(),
                             coordinator: coordinator)
                }

            }
            .frame(width: width, height: 550)
        }
        .navigationTitle("Products")
        .showErrorMessega(errorMessage: viewModel.errorMessage)
        .showProgressView(isLoading: viewModel.isLoading)
        .background(Color.customBackground.ignoresSafeArea())
        .toolbar {
            ToolbarItem {
                Button {
                    coordinator.activeTab = .bag
                } label: {
                    Label("", systemImage: "bag")
                }

            }
        }
    }
    
    private func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }
}

#Preview {
    NavigationView {
        ProductsView()
            .environmentObject(MainTabCoordinator())
    }
}
