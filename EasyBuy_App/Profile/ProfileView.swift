//
//  ProfileView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct ProfileView: View {
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
    ProfileView()
        .environmentObject(AppState())
}
