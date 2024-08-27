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
    @State private var searchText = ""
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(viewModel.categories.enumerated()), id: \.offset) { index, category in
                        Button {
                            coordinator.productsStack.append(.products)
                        } label: {
                            VStack {
                                Spacer()
                                Spacer()
                                Image(viewModel.categoriesImage[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 85)
                                                                
                                Text(category)
                                    .frame(height: 35 ,alignment: .center)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(.lable)
                                    .padding(.bottom, 5)
                            }
                            .frame(width: 105, height: 125)
                            .background(Color.itemBackground)
                            .clipShape(.rect(cornerRadius: 15))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.app, lineWidth: 0.5)
                        }
                        .padding(.all, 2)
                    }
                }
                .padding()
            }
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.products) { product in
                    VStack {
                        if let data = product.imagesData.first, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        } else {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.6)
                                .progressViewStyle(.circular)
                        }
                        
                        Text(product.name)
                            .padding(.horizontal)
                        Text("\(product.price) грн.")
                            .padding(.horizontal)
                    }
                    .frame(height: 300)
                    .background(Color.itemBackground)
                    .clipShape(.rect(cornerRadius: 25))
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.app, lineWidth: 0.5)
                    }
                    .padding(.all, 2)
                }
            }
            .padding()
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
