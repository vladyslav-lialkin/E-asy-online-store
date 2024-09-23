//
//  CategoryProductsView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 29.08.2024.
//

import SwiftUI

struct CategoryProductsView: View {
    
    @EnvironmentObject var coordinator: MainTabCoordinator
    @StateObject private var viewModel: CategoryProductsViewModel
    @State private var searchText = ""
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private var sortProduct: [Product] {
        if searchText.isEmpty {
            viewModel.products
        } else {
            viewModel.products.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(sortProduct) { product in
                    ProductGridView(url: product.imagesUrl.first,
                                    title: product.name,
                                    price: product.price,
                                    id: product.id, 
                                    coordinator: coordinator)
                    .frame(height: 300)
                }
            }
            .padding()
            .searchable(text: $searchText)
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
        .refreshable {
            viewModel.startCategoryProducts()
        }
    }
    
    init(category: CategoryEnum.RawValue) {
        _viewModel = StateObject(wrappedValue: CategoryProductsViewModel(category: category))
    }
}

#Preview {
    NavigationView {
        CategoryProductsView(category: CategoryEnum.rawValue(3))
            .environmentObject(MainTabCoordinator())
    }
}
