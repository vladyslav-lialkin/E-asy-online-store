//
//  ProfileCoordinatorView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 22.08.2024.
//

import SwiftUI

struct ProfileCoordinatorView: View {
    @EnvironmentObject var coordinator: MainTabCoordinator
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NStack(stack: $coordinator.profileStack) { screens in
            switch screens {
            case .profile:
                ProfileView(appState: appState)
            }
        }
    }
}

#Preview {
    ProfileCoordinatorView()
        .environmentObject(MainTabCoordinator())
}


