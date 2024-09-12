//
//  ProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI
import Combine

class ProductsViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var isLoading = false
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
    
    @Published var iPhonesImagesUrl: [URL?] = []
    
    @Published var iPhonesID: [UUID?] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    let categoriesTitle = ["iPhone", "Apple\nWatch", "iPad", "Mac", "Apple\nVision Pro", "AirPods", "Apple TV 4K", "HomePod", "AirTag"]
    
    // MARK: - Init
    init() {
        startProducts()
        
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                self?.startProducts()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Products
    func startProducts() {
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
    }
    
    // MARK: - Update isLoading
    func isLoading(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = bool
        }
    }
    
    
    // MARK: - Error Handling Methods
    func updateError(_ error: LocalizedStringKey?) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = error
            self?.isLoading = false
        }
    }
}
