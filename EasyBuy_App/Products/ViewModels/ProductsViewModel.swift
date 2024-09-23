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
                sleep(10)
                withAnimation {
                    errorMessage = nil
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
                UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E"),
                UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E"),
                UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")
            ]
        }.value
        isLoading = false
    }
}
