//
//  ProfileViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 02.10.2024.
//

import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: BaseViewModel {
    // MARK: - Property
    @Published var user: User?
    @AppStorage("emoji") var emoji = String()

    // MARK: - Init
    override init() {
        super.init()
        
        if emoji.isEmpty {
            emoji = "🙂"
        }
    }
    
    // MARK: - Start Profile
    override func reloadData() async {
        await fetchUser()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    private func fetchUser() async {
        do {
            guard let url = URL(string: Constant.startURL(.users, .profile)) else {
                throw HttpError.badURL
            }
                                
            let user: User = try await fetchData(from: url)
            
            withAnimation {
                self.user = user
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
//            print("fetchUser:", error)
        }
    }
}
