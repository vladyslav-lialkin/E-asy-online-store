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
                ProfileView()
            case .orders(let rawValue):
                EmptyView()
            case .order(let id):
                EmptyView()
            case .personalData:
                EmptyView()
            case .notification:
                EmptyView()
            case .settings:
                EmptyView()
            case .requestAccountDeletion:
                EmptyView()
            }
        }
    }
}

#Preview {
    ProfileCoordinatorView()
        .environmentObject(MainTabCoordinator())
        .environmentObject(AppState())
}


