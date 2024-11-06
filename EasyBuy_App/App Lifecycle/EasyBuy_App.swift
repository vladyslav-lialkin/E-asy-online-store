//
//  EasyBuy_App.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import SwiftUI
import GoogleSignIn
//import FacebookLogin

@main
struct EasyBuy_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var appState = AppState()
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            LaunchScreenView {
                ZStack {
                    if appState.isAuthenticated {
                        MainTabView()
                            .environmentObject(appState)
                            .transition(.move(edge: .trailing))
                    } else {
                        SignUpLogInCoordinatorView()
                            .environmentObject(appState)
                            .transition(.move(edge: .leading))
                    }
                }
                .overlay(alignment: .center) {
                    if !networkMonitor.isConnected {
                        Rectangle()
                            .fill(.regularMaterial)
                            .ignoresSafeArea()
                            .overlay {
                                Text("no_internet_connection")
                                    .foregroundColor(.red)
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color(uiColor: .systemGray2))
                                            .opacity(0.3)
                                    }
                            }
                    }
                }
                .animation(.linear, value: appState.isAuthenticated)
                .animation(.linear, value: networkMonitor.isConnected)
                .onOpenURL { url in
//                    ApplicationDelegate.shared.application(UIApplication.shared,
//                                                           open: url,sourceApplication: nil,
//                                                           annotation: UIApplication.OpenURLOptionsKey.annotation)
                    
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
}
