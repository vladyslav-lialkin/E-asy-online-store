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

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Button {
                if !KeychainHelper.deleteToken() {
                    print("Don't delete Token")
                }
                appState.checkAuthentication()
            } label: {
                Text("Log Out")
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
