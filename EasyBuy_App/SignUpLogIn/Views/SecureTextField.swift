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
    
    @Binding var password: String
    var titleKey: LocalizedStringKey
    
    init(_ titleKey: LocalizedStringKey, password: Binding<String>) {
        self.titleKey = titleKey
        self._password = password
    }
    
    var body: some View {
        HStack {
            ZStack {
                TextField(titleKey, text: $password)
                    .focused($focused, equals: .unSecure)
                    .autocapitalization(.words)
                    .opacity(showPassword ? 1 : 0)
                
                SecureField(titleKey, text: $password)
                    .focused($focused, equals: .secure)
                    .autocapitalization(.sentences)
                    .opacity(showPassword ? 0 : 1)
            }
            
            Button {
                showPassword.toggle()
                focused = focused == .secure ? .unSecure : .secure
            } label: {
                Image(systemName: self.showPassword ? "eye.slash" : "eye")
                    .foregroundStyle(.label)
                    .frame(width: 40, height: 40)
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
