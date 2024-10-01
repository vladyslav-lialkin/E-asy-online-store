//
//  ProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI
import Combine

@MainActor
class ProductsViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var iPhonesImagesUrl: [URL?] = []
    @Published var iPhonesID: [UUID?] = []
    
    @Published var errorMessage: LocalizedStringKey? {
        didSet {
            if errorMessage != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                    withAnimation {
                        self?.errorMessage = nil
                    }
                }
            }
        }
    }
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    
    let categoriesTitle = ["iPhone", "Apple\nWatch", "iPad", "Mac", "Apple\nVision Pro", "AirPods", "Apple TV 4K", "HomePod", "AirTag"]
    
    // MARK: - Init
    init() {
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.startProducts()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Products
    func startProducts() async {
        await Task {
            iPhonesImagesUrl = [
                URL(string: "https://i.imgur.com/RvgrlFp.png"),
                URL(string: "https://i.imgur.com/RvgrlFp.png"),
                URL(string: "https://i.imgur.com/RvgrlFp.png")
            ]
            
            iPhonesID = [
                UUID(uuidString: "864FA5BE-D4EB-483E-BA32-67D3B265312B"),
                UUID(uuidString: "864FA5BE-D4EB-483E-BA32-67D3B265312B"),
                UUID(uuidString: "864FA5BE-D4EB-483E-BA32-67D3B265312B")
            ]
        }.value
        isLoading = false
    }
}
