//
//  ProfileView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct ProfileView: View {
    
    let appState: AppState
    
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
    ProfileView(appState: AppState())
//        .environmentObject(AppState())
}
