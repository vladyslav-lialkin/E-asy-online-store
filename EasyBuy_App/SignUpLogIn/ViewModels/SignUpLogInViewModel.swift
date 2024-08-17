//
//  SignUpLogInViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 12.08.2024.
//

import SwiftUI
import CryptoKit
import GoogleSignIn


class SignUpLogInViewModel: ObservableObject {
    // MARK: - Property
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var errorUsername: String?
    @Published var errorEmail: String?
    @Published var errorPassword: String?
    @Published var errorMessage: String? {
        didSet {
            if errorMessage != nil {
                startErrorTimeout()
            }
        }
    }
    
    @Published var isLogin: Bool
    
    @Published var isLoading = false
    
    var title: LocalizedStringKey {
        isLogin ? "Login To Your \nAccount" : "Create Your New \nAccount"
    }
    
    var description: LocalizedStringKey {
        isLogin ? "Please sign in to your account" : "Sign up to start buying your favorite apple products"
    }
    
    var buttonTitle: LocalizedStringKey {
        isLogin ? "Sign In" : "Sign Up"
    }
    
    var botomDescription: LocalizedStringKey {
        isLogin ? "Don't have an account?" : "Already have an account?"
    }
    
    // MARK: - Init
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
    }
    
    deinit {
        print("deinit: SignUpLogInViewModel")
    }
    
    private func startErrorTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            withAnimation {
                self?.errorMessage = nil
            }
        }
    }
    
    // MARK: - Error Handling Methods
    
    enum UpdateError {
        case username
        case email
        case password
        case message
    }
    
    private func updateError(_ error: String?, for field: UpdateError) {
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
            }
        }
    }
    
    private func handleModelError(_ modelError: ModelError) -> Bool {
        var hasError = false
        
        if modelError.reason.contains("Email is already in use.") {
            updateError("Email is already in use.", for: .email)
            hasError = true
        }
        
        if modelError.reason.contains("Username is already in use.") {
            updateError("Username is already in use.", for: .username)
            hasError = true
        }
        
        if modelError.reason.contains("Email does not exist.") {
            updateError("Email does not exist.", for: .email)
            hasError = true
        }
        
        if modelError.reason.contains("Incorrect password.") {
            updateError("Incorrect password.", for: .password)
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
        
        errorMessage = "There is an issue with the connection to the server. Please try again later."
    }

    // MARK: - Validation Methods
    
    private func validateUsername() -> Bool {
        guard !username.isEmpty else {
            updateError("Enter username", for: .username)
            return false
        }
        updateError(nil, for: .username)
        
        return true
    }
    
    private func validateEmail(_ email: String) -> Bool {
        guard !email.isEmpty else {
            updateError("Enter email", for: .email)
            return false
        }
        updateError(nil, for: .email)
        
        let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailPredicate.evaluate(with: email) {
            return true
        } else {
            updateError("This email does not exist", for: .email)
            return false
        }
    }
    
    func validatePasswordStrength(password: String) -> Bool {
        guard !password.isEmpty else {
            updateError("Enter password", for: .password)
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
            updateError("Password is very weak", for: .password)
            return false
        }

        let optionalCriteriaMet = specialCharacterRequirement ? 1 : 0

        switch optionalCriteriaMet {
        case 0:
            return true
        case 1:
            return true
        default:
            updateError("Password is very weak", for: .password)
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
    
    func hashUserID(_ userID: String) -> String {
        let hash = SHA256.hash(data: userID.data(using: .utf8)!)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
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
    
    // MARK: - Google Sign-In
    
    func signInWithGoogle() async throws {
        guard let topVc = await TopViewController.find() else {
            updateError("Could not sign in with Google. Please try again later.", for: .message)
            return
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVc)
        
        guard let userID = result.user.userID else {
            updateError("Could not sign in with Google. Please try again later.", for: .message)
            return
        }
        
        guard let profile = result.user.profile else {
            updateError("Could not sign in with Google. Please try again later.", for: .message)
            return
        }
        
        let user = UserSignUp(email: profile.email, password: hashUserID(userID), username: "User_G:" + UUID().uuidString)
        let (data, _) = try await registerRequest(user: user)
        
        if (try? JSONDecoder().decode(ModelError.self, from: data)) != nil {
            print("error with Google register")
        }

        let (dataSignIn, _) = try await signInRequest(email: profile.email, password: hashUserID(userID))
        
        if (try? JSONDecoder().decode(ModelError.self, from: dataSignIn)) != nil {
            updateError("Could not sign in with Google. Please try again later.", for: .message)
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
    }
                    
    // MARK: - Apple Sign-In
    
    func signInWithApple() {}
}
