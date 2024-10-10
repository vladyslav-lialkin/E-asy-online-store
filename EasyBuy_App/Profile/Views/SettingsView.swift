//
//  SettingsView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 09.10.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var coordinator: MainTabCoordinator
        
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                Spacer().padding(.top)
                
                VStack {
                    quickActionButton(label: "Security", icon: "lock") {
                        coordinator.profileStack.append(.security)
                    }
                    
                    Divider().customStroke(strokeSize: 0.15, strokeColor: .app)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    quickActionButton(label: "Privacy Policy", icon: "list.bullet.clipboard") {
                        coordinator.profileStack.append(.privacyPolicy)
                    }
                    
                    quickActionButton(label: "Terms and conditions", icon: "book") {
                        coordinator.profileStack.append(.termsAndConditions)
                    }
                    
                    quickActionButton(label: "Help and support", icon: "questionmark.circle") {
                        coordinator.profileStack.append(.helpAndSupport)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Settings")
    }
    
    // MARK: - Helper Buttons
    func quickActionButton(label: String, icon: String, _ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                Text(label)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .font(.callout.bold())
            .padding(.horizontal, 30)
            .capsuleButtonStyle()
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(MainTabCoordinator())
    }
    .tint(.app)
}
