//
//  EasyBuy_App.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import SwiftUI
import GoogleSignIn

@main
struct EasyBuy_App: App {
    @StateObject private var appState = AppState()
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if appState.isAuthenticated {
                    ContentView()
                        .environmentObject(appState)
                        .transition(.move(edge: .trailing))
                } else {
                    SignUpLogInCoordinatorView()
                        .environmentObject(appState)
                        .transition(.move(edge: .leading))
                }
            }
            .overlay(alignment: .top) {
                if !networkMonitor.isConnected {
                    Text("no_internet_connection")
                        .foregroundColor(.red)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(uiColor: .systemGray2))
                                .opacity(0.9)
                        }
                        .transition(.move(edge: .top))
                }
            }
            .animation(.easeInOut, value: appState.isAuthenticated)
            .animation(.easeOut, value: networkMonitor.isConnected)
            .onOpenURL { url in
                if GIDSignIn.sharedInstance.handle(url) {
                    return
                }
            }
            .onAppear {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    // Check if `user` exists; otherwise, do something with `error`
                }
            }
        }
    }
}
