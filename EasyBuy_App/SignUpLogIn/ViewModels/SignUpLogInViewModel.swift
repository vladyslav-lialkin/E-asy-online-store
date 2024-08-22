//
//  SignUpLogInViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 12.08.2024.
//

import SwiftUI
import CryptoKit
import GoogleSignIn
//import FacebookLogin
import AuthenticationServices


class SignUpLogInViewModel: NSObject, ObservableObject {
    
    // MARK: - Property
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var errorUsername: LocalizedStringKey?
    @Published var errorEmail: LocalizedStringKey?
    @Published var errorPassword: LocalizedStringKey?
    @Published var errorMessage: LocalizedStringKey? {
        didSet {
            if errorMessage != nil {
                startErrorTimeout()
            }
        }
    }
    
    @Published var isLogin: Bool
    @Published var isLoading: Bool = false
    
    var title: LocalizedStringKey {
        isLogin ? "log_in_title" : "sign_up_title"
    }
    
    var descriptionText: LocalizedStringKey {
        isLogin ? "log_in_description" : "sign_up_description"
    }
    
    var primaryButtonTitle: LocalizedStringKey {
        isLogin ? "log_in_primary_button_title" : "sign_up_primary_button_title"
    }
    
    var bottomDescriptionText: LocalizedStringKey {
        isLogin ? "log_in_bottom_description_text" : "sign_up_bottom_description_text"
    }
    
    var secondaryButtonTitle: LocalizedStringKey {
        isLogin ? "log_in_secondary_button_title" : "sign_up_secondary_button_title"
    }
    
    // MARK: - Init and DeInit
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
    }
    
    deinit {
        print("deinit: SignUpLogInViewModel")
    }
    
    
    // MARK: - Error Handling Methods
    
    enum UpdateError {
        case username
        case email
        case password
        case message
    }
    
    private func updateError(_ error: LocalizedStringKey?, for field: UpdateError) {
        DispatchQueue.main.async { [weak self] in
            switch field {
            case .username:
                self?.errorUsername = error
            case .email:
                self?.errorEmail = error
            case .password:
                self?.errorPassword = error
            case .message:
                self?.errorMessage = error
                self?.isLoading = false
            }
        }
    }
    
    private func handleModelError(_ modelError: ModelError) -> Bool {
        var hasError = false
        
        if modelError.reason.contains("Email is already in use.") {
            updateError("email_is_already_in_use", for: .email)
            hasError = true
        }
        
        if modelError.reason.contains("Username is already in use.") {
            updateError("username_is_already_in_use", for: .username)
            hasError = true
        }
        
        if modelError.reason.contains("Email does not exist.") {
            updateError("email_does_not_exist", for: .email)
            hasError = true
        }
        
        if modelError.reason.contains("Incorrect password.") {
            updateError("incorrect_password", for: .password)
            hasError = true
        }
        
        return hasError
    }
    
    func handleHttpError(_ error: HttpError) {
        switch error {
        case .badURL:
            print("The URL provided is invalid.")
        case .badResponse:
            print("Received a bad response from the server.")
        case .errorDecodingData:
            print("Failed to decode the data.")
        case .invalidURL:
            print("The URL is invalid.")
        case .tokenDontSave:
            print("The token was not saved properly.")
        }
        
        errorMessage = "server_connection_issue"
        isLoading = false
    }
    
    private func startErrorTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            withAnimation {
                self?.errorMessage = nil
            }
        }
    }

    // MARK: - Validation Methods
    
    private func validateUsername() -> Bool {
        guard !username.isEmpty else {
            updateError("enter_username", for: .username)
            return false
        }
        updateError(nil, for: .username)
        
        return true
    }
    
    private func validateEmail(_ email: String) -> Bool {
        guard !email.isEmpty else {
            updateError("enter_email", for: .email)
            return false
        }
        updateError(nil, for: .email)
        
        let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailPredicate.evaluate(with: email) {
            return true
        } else {
            updateError("this_email_does_not_exist", for: .email)
            return false
        }
    }
    
    func validatePasswordStrength(password: String) -> Bool {
        guard !password.isEmpty else {
            updateError("enter_password", for: .password)
            return false
        }
        updateError(nil, for: .password)
        
        let lengthRequirement = password.count >= 8
        let uppercaseRequirement = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        let lowercaseRequirement = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        let digitRequirement = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
        
        let specialCharacterRequirement = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*(),.?\":{}|<>]+.*").evaluate(with: password)
        
        let mandatoryCriteriaMet = [lengthRequirement, uppercaseRequirement, lowercaseRequirement, digitRequirement].allSatisfy { $0 }
        
        if !mandatoryCriteriaMet {
            updateError("password_is_very_weak", for: .password)
            return false
        }
        
        let optionalCriteriaMet = specialCharacterRequirement ? 1 : 0
        
        switch optionalCriteriaMet {
        case 0:
            return true
        case 1:
            return true
        default:
            updateError("password_is_very_weak", for: .password)
            return false
        }
    }
    
    // MARK: - HTTP Request's
    
    private func signInRequest(email: String, password: String) async throws -> (Data, URLResponse) {
        guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.login.rawValue) else {
            throw HttpError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let authString = "Basic \(Data("\(email):\(password)".utf8).base64EncodedString())"
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        
        return try await URLSession.shared.data(for: request)
    }
    
    private func registerRequest(user: UserSignUp) async throws -> (Data, URLResponse) {
        guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.users.rawValue + Endpoints.register.rawValue) else {
            throw HttpError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.httpBody = try? JSONEncoder().encode(user)
        
        return try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Login and Signup Methods
    
    func logIn() async throws {
        let isValidEmail = validateEmail(email)
        let isValidPasswordStrength = validatePasswordStrength(password: password)
        
        guard isValidEmail, isValidPasswordStrength else { return }
        
        let (data, _) = try await signInRequest(email: email, password: password)
        
        if let modelError = try? JSONDecoder().decode(ModelError.self, from: data) {
            if handleModelError(modelError) { return }
        }
        
        guard let token = try? JSONDecoder().decode(TokenModel.self, from: data) else {
            print("Don't decoding token")
            throw HttpError.errorDecodingData
        }
        
        if !KeychainHelper.save(token: token.value) {
            print("Don't save token")
            throw HttpError.tokenDontSave
        }
    }
    
    func signUp() async throws {
        let isValidUsername = validateUsername()
        let isValidEmail = validateEmail(email)
        let isValidPasswordStrength = validatePasswordStrength(password: password)
        
        guard isValidUsername, isValidEmail, isValidPasswordStrength else { return }
        
        let user = UserSignUp(email: email, password: password, username: username)
        let (data, _) = try await registerRequest(user: user)
        
        if let modelError = try? JSONDecoder().decode(ModelError.self, from: data) {
            if handleModelError(modelError) { return }
        }
        
        try await logIn()
    }
    
    // MARK: - Sign-In Methods
    
    func hashUserID(_ userID: String) -> String {
        let hash = SHA256.hash(data: userID.data(using: .utf8)!)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    // MARK: Google Sign-In
    
    func signInWithGoogle() {
        Task {
            do {
                isLoading = true
                guard let topVc = await TopViewController.find() else {
                    updateError("google_sign_in_error", for: .message)
                    return
                }
                
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVc)
                
                guard let userID = result.user.userID else {
                    updateError("google_sign_in_error", for: .message)
                    return
                }
                
                guard let profile = result.user.profile else {
                    updateError("google_sign_in_error", for: .message)
                    return
                }
                
                let user = UserSignUp(email: profile.email, password: hashUserID(userID), username: "User_G:" + UUID().uuidString)
                let (data, _) = try await registerRequest(user: user)
                
                if (try? JSONDecoder().decode(ModelError.self, from: data)) != nil {
                    print("error when registering with Google")
                }
                
                let (dataSignIn, _) = try await signInRequest(email: profile.email, password: hashUserID(userID))
                
                if (try? JSONDecoder().decode(ModelError.self, from: dataSignIn)) != nil {
                    updateError("google_sign_in_error", for: .message)
                    return
                }
                
                guard let token = try? JSONDecoder().decode(TokenModel.self, from: dataSignIn) else {
                    print("Don't decoding token")
                    throw HttpError.errorDecodingData
                }
                
                if !KeychainHelper.save(token: token.value) {
                    print("Don't save token")
                    throw HttpError.tokenDontSave
                }
            } catch let error as HttpError {
                handleHttpError(error)
            } catch {
                print("An unexpected error occurred: \(error)")
            }
            isLoading = false
        }
    }
    
    // MARK: Fecebook Sign-In
//
//    func signInWithFaceBook() {
//        Task {
//            isLoading = true
//            
//            guard let topVc = await TopViewController.find() else {
//                throw URLError(.cannotFindHost)
//            }
//            
//            let loginManager = LoginManager()
//            
//            loginManager.logIn(permissions: ["public_profile", "email"], from: topVc) { (result, error) in
//                if let error = error {
//                    print(error)
//                } else if let result = result, !result.isCancelled {
//                    self.fetchFacebookUserData()
//                } else {
//                    print("isCancelled")
//                    self.isLoading = false
//                }
//            }
//        }
//    }
//    
//    private func fetchFacebookUserData() {
//        guard AccessToken.current != nil else {
//            updateError("facebook_sign_in_error", for: .message)
//            return
//        }
//        
//        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"])
//        
//        request.start { (_, result, error) in
//            if let error = error {
//                print(error)
//            } else if let userData = result as? [String: Any] {
//                self.handleFacebookUserData(userData: userData)
//            } else {
//                print("isCancelled")
//                self.isLoading = false
//            }
//        }
//    }
//    
//    private func handleFacebookUserData(userData: [String: Any]) {
//        Task {
//            do {
//                guard let userID = userData["id"] as? String, let name = userData["name"] as? String else {
//                    updateError("facebook_sign_in_error", for: .message)
//                    return
//                }
//                
//                let user = UserSignUp(email: hashUserID(name), password: hashUserID(userID), username: "User_F:" + UUID().uuidString)
//                
//                let (data, _) = try await registerRequest(user: user)
//                
//                if (try? JSONDecoder().decode(ModelError.self, from: data)) != nil {
//                    print("error when registering with Facebook")
//                }
//                
//                let (dataSignIn, _) = try await signInRequest(email: hashUserID(name), password: hashUserID(userID))
//                
//                if (try? JSONDecoder().decode(ModelError.self, from: dataSignIn)) != nil {
//                    updateError("facebook_sign_in_error", for: .message)
//                    return
//                }
//                
//                guard let token = try? JSONDecoder().decode(TokenModel.self, from: dataSignIn) else {
//                    throw HttpError.errorDecodingData
//                }
//                
//                if !KeychainHelper.save(token: token.value) {
//                    throw HttpError.tokenDontSave
//                }
//            } catch let error as HttpError {
//                handleHttpError(error)
//            } catch {
//                print("An unexpected error occurred: \(error)")
//            }
//            isLoading = false
//        }
//    }
    
    // MARK: Apple Sign-In
    
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func handleAppleAuthorization(credential: ASAuthorizationAppleIDCredential) {
        let userID = credential.user
        let email = credential.email
        
        Task {
            do {
                isLoading = true
                
                guard let emailToUse = email else {
                    updateError("apple_sign_in_error", for: .message)
                    return
                }
                                
                let user = UserSignUp(email: emailToUse, password: hashUserID(userID), username: "User_A:" + UUID().uuidString)
                let (data, _) = try await registerRequest(user: user)
                
                if (try? JSONDecoder().decode(ModelError.self, from: data)) != nil {
                    print("error when registering with Apple")
                }
                
                let (dataSignIn, _) = try await signInRequest(email: emailToUse, password: hashUserID(userID))
                
                if (try? JSONDecoder().decode(ModelError.self, from: dataSignIn)) != nil {
                    updateError("apple_sign_in_error", for: .message)
                    return
                }
                
                guard let token = try? JSONDecoder().decode(TokenModel.self, from: dataSignIn) else {
                    print("Don't decoding token")
                    throw HttpError.errorDecodingData
                }
                
                if !KeychainHelper.save(token: token.value) {
                    print("Don't save token")
                    throw HttpError.tokenDontSave
                }
                isLoading = false
            } catch let error as HttpError {
                handleHttpError(error)
            } catch {
                print("An unexpected error occurred: \(error)")
            }
        }
    }
}

extension SignUpLogInViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handleAppleAuthorization(credential: appleIDCredential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        updateError("apple_sign_in_error", for: .message)
    }
}
