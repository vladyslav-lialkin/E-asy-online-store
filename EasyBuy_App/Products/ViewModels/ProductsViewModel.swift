//
//  ProductsViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI

class ProductsViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var isLoading = false
    @Published var errorMessage: LocalizedStringKey? {
        didSet {
            if errorMessage != nil {
                startErrorTimeout()
            }
        }
    }
    
    let iPhonesImagesUrl: [URL?] = [
        URL(string: "https://i.imgur.com/RvgrlFp.png"),
        URL(string: "https://i.imgur.com/RvgrlFp.png"),
        URL(string: "https://i.imgur.com/RvgrlFp.png")
    ]
    
    let iPhonesID: [UUID?] = [
        UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E"),
        UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E"),
        UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")
    ]
    
    
    let categoriesTitle = ["iPhone", "Apple\nWatch", "iPad", "Mac", "Apple\nVision Pro", "AirPods", "Apple TV 4K", "HomePod", "AirTag"]
    
    // MARK: - Init
    init() {
//        isLoading = true
//        Task {
//            do {
//                let imagesData = try await fetchImages()
//                
//                DispatchQueue.main.async { [weak self] in
//                    self?.imagesData = imagesData
//                }
//            } catch let error as HttpError {
//                updateError(HandlerError.httpError(error))
//            }
//            isLoading(false)
//        }
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
    
    private func startErrorTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            withAnimation {
                self?.errorMessage = nil
            }
        }
    }
}
