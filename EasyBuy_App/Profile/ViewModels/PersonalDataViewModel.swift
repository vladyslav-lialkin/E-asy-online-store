//
//  PersonalDataViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import SwiftUI

@MainActor
final class PersonalDataViewModel: BaseViewModel {
    // MARK: - Property
    @Published var user: User?
    @Published var isEmojiPicker = false
    @AppStorage("emoji") var emoji = String()
            
    // MARK: - Init
    override init() {
        super.init()
    }
    
    // MARK: - Start PersonalData
    override func reloadData() async {
        await fetchUserData()
        isLoading = false
    }
    
    // MARK: - Fetch Methods
    func fetchUserData() async {
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
            print("fetchUserData:", error)
        }
    }
}
