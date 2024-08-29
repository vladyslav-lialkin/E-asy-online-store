//
//  CategoryProducts.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI

struct CategoryProductView: View {
    
    @EnvironmentObject var coordinator: MainTabCoordinator
    @ObservedObject private var viewModel: CategoryProductsViewModel
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.products) { product in
                    ProductGridView(url: product.imagesUrl.first,
                                    title: product.name,
                                    price: product.price,
                                    id: product.id, 
                                    coordinator: coordinator)
                    .frame(height: 300)
                }
            }
            .padding()
            .searchable(text: $viewModel.searchText) {
            }
            .onAppear()
        }
        .navigationTitle(viewModel.category)
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
    
    init(category: CategoryEnum.RawValue) {
        self.viewModel = CategoryProductsViewModel(category: category)
    }
}

#Preview {
    NavigationView {
        CategoryProductView(category: CategoryEnum.rawValue(3))
            .environmentObject(MainTabCoordinator())
    }
}
