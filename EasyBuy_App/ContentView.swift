//
//  ContentView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import SwiftUI

struct User: Identifiable {
    var id: UUID?
    var name: String?
    var lastname: String?
    var username: String?
    var email: String
    var city: String?
    var updatedAt: Date?
}

struct UserSignUp: Codable {
    let email: String
    let password: String
    let username: String
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                Task {
                    guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.users.rawValue + Endpoints.register.rawValue) else {
                        return
                    }
                    
                    let user = UserSignUp(email: "vladyslav@gmail.com", password: "Vladyslav1234", username: "Petro")
                    
//                    try await HttpClient.shared.sendData(to: url, object: user, httpMethod: .POST)
                }
            } label: {
                Text("Sign Up")
            }

            Button {
                Task {
                    guard let url = URL(string: Constants.baseURL.rawValue + Endpoints.login.rawValue) else {
                        return
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                                        
                    let userPasswordString = "vladyslav@gmail.com:Vladyslav1234"
                    guard let userPasswordData = userPasswordString.data(using: .utf8) else {
                        return
                    }
                    let base64EncodedCredential = userPasswordData.base64EncodedString()
                    let authString = "Basic \(base64EncodedCredential)"
                    
                    request.setValue(authString, forHTTPHeaderField: "Authorization")
                    
//                    let (data, response) = try await URLSession.shared.data(for: request)
//                    print(String(data: data, encoding: .utf8) as Any)
                }
            } label: {
                Text("Log In")
            }

        }
        .padding()
//        .task {
//            let login = "johan@devscorch.com"
//            let password = "Test12345678"
//
//            let url = URL(string: "http://127.0.0.1:8080/login")
//            //            let url = URL(string: "http://127.0.0.1:8080/users/courses")
//            var request = URLRequest(url: url!)
//            request.httpMethod = "POST"
//            //            request.httpMethod = "GET"
//
//            let userPasswordString = "\(login):\(password)"
//            let userPasswordData = userPasswordString.data(using: .utf8)
//            let base64EncodedCredential = userPasswordData!.base64EncodedString()
//            let authString = "Basic \(base64EncodedCredential)"
//            //            let authString = "Bearer oud0wBhzXDf35HgreEgHBA==" //Tokin
//            print(authString)
//
//            request.setValue(authString, forHTTPHeaderField: "Authorization")
//
//            Task {
//                let (data, response) = try await URLSession.shared.data(for: request)
//                print(String(data: data, encoding: .utf8))
//            }
//        }
    }
}

//#Preview {
//    ContentView()
//}
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
}

struct EmailValidationView: View {
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true

    var body: some View {
        VStack {
            TextField("Enter Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            Button(action: {
                isEmailValid = isValidEmail(email)
            }) {
                Text("Validate Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(isEmailValid ? Color.green : Color.red)
                    .cornerRadius(15.0)
            }

            Text(isEmailValid ? "Valid Email" : "Invalid Email")
                .font(.subheadline)
                .foregroundColor(isEmailValid ? .green : .red)
                .padding()
        }
        .padding()
    }
}

struct EmailValidationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailValidationView()
    }
}
