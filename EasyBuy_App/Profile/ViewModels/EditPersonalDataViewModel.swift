//
//  EditPersonalDataViewModel.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 08.10.2024.
//


import SwiftUI
import Combine

@MainActor
final class EditPersonalDataViewModel: ObservableObject {
    // MARK: - Property
    @Published var title = "Title"
    @Published var editField = ""
    @Published var field: PersonalDataField
    @Published var isSuccess = false  {
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
    @Published var errorField: LocalizedStringKey?
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
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
            
    // MARK: - Init
    init(field: PersonalDataField) {
        self.field = field
        
        NotificationCenter.default.publisher(for: .didRestoreInternetConnection)
            .sink { [weak self] _ in
                Task {
                    await self?.fetchField()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Start Favorites
    func startEditPersonalData() async {
        await fetchField()
        isLoading = false
    }
    
    // MARK: - Error Handling Methods
    
    private func handleModelError(_ modelError: ModelError) -> Bool {
        var hasError = false
        
        if modelError.reason.contains("Email is already in use.") {
            errorField = "email_is_already_in_use"
            hasError = true
        }
        
        if modelError.reason.contains("Username is already in use.") {
            errorField = "username_is_already_in_use"
            hasError = true
        }
        
        if modelError.reason.contains("PhoneNumber is already in use.") {
            errorField = "phonenumber_is_already_in_use"
            hasError = true
        }
        
        return hasError
    }
    
    // MARK: - Validation Methods
    private func validateField() -> Bool {
        guard !editField.isEmpty else {
            errorField = "Enter something in this field."
            return false
        }
        errorField = nil

        switch field {
        case .userName:
            return true
        case .firstName, .lastName:
            return true
        case .phoneNumber:
            let phoneRegEx = "^[+]?[0-9]{1,4}?[-.\\s]?([0-9]{1,3}[-.\\s]?){1,2}[0-9]{3,4}[-.\\s]?[0-9]{1,4}$"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
            if !phonePredicate.evaluate(with: editField) {
                errorField = "invalid_phone_number_format"
                return false
            }
        case .emailAdress:
            let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if !emailPredicate.evaluate(with: editField) {
                errorField = "this_email_does_not_exist"
                return false
            }
        }
        return true
    }
    
    // MARK: - HTTP Request's
    
    private func updateFieldRequest(object: UpdateUserDTO) async throws -> (Data, URLResponse) {
        guard let url = URL(string: Constant.startURL(.users, .profile, .update)) else {
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
    
    // MARK: - Fetch Methods
    private func fetchField() async {
        do {
            guard let url = URL(string: Constant.startURL(.users, .profile)) else {
                throw HttpError.badURL
            }
            
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            if KeychainHelper.save(token: "4ax1JPZFQZSyG1VRTTpUbw==") {
                print("Test Token added")
            } else  {
                print("Test Token don't added")
            }
            #endif
                                
            let user: User = try await HttpClient.shared.fetch(url: url, token: KeychainHelper.getToken())
            
            withAnimation {
                (editField, title) = switch field {
                case .userName:
                    (user.username, "Usermame")
                case .firstName:
                    (user.name ?? "", "First Name")
                case .lastName:
                    (user.lastname ?? "", "Last Name")
                case .phoneNumber:
                    (user.phoneNumber ?? "", "Phone Number")
                case .emailAdress:
                    (user.email, "E-mail Adress")
                }
            }
        } catch let error as HttpError {
            errorMessage = HandlerError.httpError(error)
        } catch {
//            print("fetchField:", error)
        }
    }
    
    // MARK: - Send Methods
    func updateField() {
        Task {
            do {
                let isValid = validateField()
                
                guard isValid else { return }
                
                let updateUserDTO: UpdateUserDTO = {
                    switch field {
                    case .userName:
                        return UpdateUserDTO(username: editField)
                    case .firstName:
                        return UpdateUserDTO(name: editField)
                    case .lastName:
                        return UpdateUserDTO(lastname: editField)
                    case .phoneNumber:
                        return UpdateUserDTO(phoneNumber: editField)
                    case .emailAdress:
                        return UpdateUserDTO(email: editField)
                    }
                }()
                
                let (data, response) = try await updateFieldRequest(object: updateUserDTO)
                                
                if let modelError = try? JSONDecoder().decode(ModelError.self, from: data) {
                    if handleModelError(modelError) { return }
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw HttpError.badResponse
                }
                
                withAnimation {
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
//                print("updateField:", error)
            }
            await fetchField()
        }
    }
}
