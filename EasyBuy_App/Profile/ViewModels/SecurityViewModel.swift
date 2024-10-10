//
//  SecurityViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 10.10.2024.
//

import Foundation
import SwiftUICore

@MainActor
final class SecurityViewModel: BaseViewModel {
    // MARK: - Property
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var errorCurrentPassword: LocalizedStringKey?
    @Published var errorNewPassword: LocalizedStringKey?
    @Published var errorConfirmPassword: LocalizedStringKey?
    @Published var isSuccess = false
    
    override init() {
        super.init()
        isLoading = false
    }
    
    // MARK: - Validation Methods
    enum PasswordType {
        case current
        case new
        case confirm
    }

    func validatePasswordStrength(type: PasswordType) -> Bool {
        switch type {
        case .current:
            return validatePassword(password: currentPassword, errorKey: &errorCurrentPassword)
        case .new:
            return validatePassword(password: newPassword, errorKey: &errorNewPassword)
        case .confirm:
            return validateConfirmPassword()
        }
    }

    private func validatePassword(password: String, errorKey: inout LocalizedStringKey?) -> Bool {
        // Перевірка на порожній пароль
        guard !password.isEmpty else {
            errorKey = "enter_password"
            return false
        }
        
        errorKey = nil
        
        // Перевірка довжини, великої літери, малої літери та числа
        let lengthRequirement = password.count >= 8
        let uppercaseRequirement = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        let lowercaseRequirement = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        let digitRequirement = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
        
        let mandatoryCriteriaMet = [lengthRequirement, uppercaseRequirement, lowercaseRequirement, digitRequirement].allSatisfy { $0 }
        
        if !mandatoryCriteriaMet {
            errorKey = "incorrect_password"
            return false
        }
        
        return true
    }

    private func validateConfirmPassword() -> Bool {
        guard newPassword == confirmPassword else {
            errorConfirmPassword = "passwords_do_not_match"
            return false
        }
        
        errorConfirmPassword = nil
        return true
    }
    
    // MARK: - HTTP Request's
    private func changePasswordRequest(object: ChangeUserPasswordDTO) async throws -> (Data, URLResponse) {
        guard let url = URL(string: Constant.startURL(.users, .profile, .changePassword)) else {
            throw HttpError.badURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.PATCH.rawValue
        request.addValue("Bearer \(try KeychainHelper.getToken())",
                         forHTTPHeaderField: "Authorization")
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        request.httpBody = try JSONEncoder().encode(object)
        
        return try await URLSession.shared.data(for: request)
    }

    // MARK: - Send Methods
    func changePassword() {
        Task {
            isLoading = true
            
            // Перевірка всіх полів
            let isValidCurrentPassword = validatePasswordStrength(type: .current)
            let isValidNewPassword = validatePasswordStrength(type: .new)
            let isValidConfirmPassword = validatePasswordStrength(type: .confirm)
            
            // Якщо не валідний хоча б один пароль - зупиняємось
            guard isValidCurrentPassword, isValidNewPassword, isValidConfirmPassword else {
                isLoading = false
                return
            }
            
            do {
                let changeUserPasswordDTO = ChangeUserPasswordDTO(oldPassword: currentPassword, newPassword: newPassword)
                
                let (data, response) = try await changePasswordRequest(object: changeUserPasswordDTO)
                
                // Перевірка на помилки в респонсі
                if let modelError = try? JSONDecoder().decode(ModelError.self, from: data) {
                    if modelError.reason.contains("Incorrect password.") {
                        errorCurrentPassword = "incorrect_password"
                        isLoading = false
                        return
                    }
                }
                
                // Перевірка коду відповіді
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw HttpError.badResponse
                }
                
                // Якщо успіх
                withAnimation {
                    currentPassword = ""
                    newPassword = ""
                    confirmPassword = ""
                    self.isSuccess = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isSuccess = false
                    }
                }
                
            } catch let error as HttpError {
                errorMessage = HandlerError.httpError(error)
            } catch {
                print("changePassword:", error)
            }
            
            isLoading = false
        }
    }
}
