//
//  SecureTextField.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 10.08.2024.
//

import SwiftUI

struct SecureTextField: View {
    
    @FocusState private var focused: focusedField?
    @State private var showPassword: Bool = false
    @State private var internalPassword: String
    
    @State var titleKey: LocalizedStringKey
    @Binding var password: String
    
    init(_ titleKey: LocalizedStringKey, password: Binding<String>) {
        _internalPassword = State(initialValue: password.wrappedValue)
        _password = password
        self.titleKey = titleKey
    }
    
    var body: some View {
        HStack {
            ZStack() {
                TextField(titleKey, text: $internalPassword)
                    .focused($focused, equals: .unSecure)
                    .autocapitalization(.words)
                    .opacity(showPassword ? 1 : 0)
                
                SecureField(titleKey, text: $internalPassword)
                    .focused($focused, equals: .secure)
                    .autocapitalization(.sentences)
                    .opacity(showPassword ? 0 : 1)
            }
            
            Button {
                showPassword.toggle()
                
                guard (focused != nil) else { return }
                focused = focused == .secure ? .unSecure : .secure
            } label: {
                Image(systemName: self.showPassword ? "eye.slash" : "eye")
                    .foregroundStyle(.lable)
                    .frame(width: 40 ,height: 40)
            }
            .onChange(of: internalPassword) { newValue in
                password = internalPassword
            }
        }        
    }
    
    enum focusedField {
        case secure, unSecure
    }
}


//#Preview {
//    @State var password = ""
//    VStack {
//        
//        SecureTextField("Password", password: $password)
//            .customTextField(color: .gray)
//    }
//}
