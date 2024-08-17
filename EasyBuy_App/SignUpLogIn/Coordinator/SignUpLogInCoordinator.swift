//
//  SignUpLogInCoordinator.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.08.2024.
//

import Foundation
import Combine

class SignUpLogInCoordinator: ObservableObject {
    @Published var stack: [SignUpLogInScreens] = [.authentication]
    
    func push(_ element: SignUpLogInScreens) {
        if !stack.contains(element) {
            stack.append(element)
        } else {
            pop()
        }
    }
    
    func pop() {
        stack.removeLast()
    }
    
    deinit {
        print("deinit: SignUpLogInCoordinator")
    }
}
