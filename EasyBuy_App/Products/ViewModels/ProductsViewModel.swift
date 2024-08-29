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
    
    @Published var imagesData = [Data]()
    let iPhonesImagesUrl: [URL?] = [
        URL(string: "https://i.imgur.com/RvgrlFp.png")
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
    
    // MARK: - Fetch Methods
    func fetchImages() async throws -> [Data] {        
        var imagesData = [Data]()
                
        for index in 0..<iPhonesImagesUrl.count {
            if let url = iPhonesImagesUrl[index] {
                imagesData += [try await HttpClient.shared.fetch(url: url)]
            } else {
                print("The URL of the photo at index \(index) is incorrect")
            }
        }

        return imagesData
    }
}
