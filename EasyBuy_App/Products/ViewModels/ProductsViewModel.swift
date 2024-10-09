//
//  ProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import Foundation

@MainActor
final class ProductsViewModel: BaseViewModel {
    // MARK: - Property
    @Published var iPhonesImagesUrl: [URL?] = []
    @Published var iPhonesID: [UUID?] = []
        
    let categoriesTitle = ["iPhone", "Apple\nWatch", "iPad", "Mac", "Apple\nVision Pro", "AirPods", "Apple TV 4K", "HomePod", "AirTag"]
    
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
