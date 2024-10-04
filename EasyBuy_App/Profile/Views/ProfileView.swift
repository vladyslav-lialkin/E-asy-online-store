//
//  ProfileView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 20.08.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var coordinator: MainTabCoordinator
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    userInfoSection
                    Spacer().frame(height: 30)
                    myOrdersSection
                    quickActionsSection
                    settingsSection
                    logOutButton
                }
                .padding(.horizontal)
                .navigationTitle("Profile")
                .task {
                    await viewModel.startUser()
                }
            }
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
        
    // MARK: - User Info Section
    var userInfoSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello, " + (viewModel.user?.username ?? "___"))
                    .customStroke(strokeSize: 1.7, strokeColor: .app)
                    .foregroundStyle(.letter)
                    .font(.title2.bold())
                    .lineLimit(1)
                
                Text(viewModel.user?.email ?? "___")
                    .foregroundStyle(.gray)
                    .font(.callout)
            }
            
            Spacer()
            
            Text(viewModel.emojis.randomElement() ?? "🙂")
                .font(.system(size: 50))
        }
    }
    
    // MARK: - My Orders Section
    var myOrdersSection: some View {
        VStack {
            HStack {
                Text("My Orders")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button("See all >") {
                    coordinator.profileStack.append(.orders(.all))
                }
                .font(.callout)
                .foregroundStyle(.gray)
            }
            
            HStack {
                orderButton(title: "New") {
                    coordinator.profileStack.append(.orders(.new))
                }
                orderButton(title: "Shipped") {
                    coordinator.profileStack.append(.orders(.shipped))
                }
            }
            HStack {
                orderButton(title: "Delivered") {
                    coordinator.profileStack.append(.orders(.delivered))
                }
                orderButton(title: "Returned") {
                    coordinator.profileStack.append(.orders(.returned))
                }
            }
        }
    }
    
    // MARK: - Quick Actions Section
    var quickActionsSection: some View {
        VStack {
            Divider().customStroke(strokeSize: 0.15, strokeColor: .app)
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            quickActionButton(label: "Personal Data", icon: "person") {
                coordinator.profileStack.append(.personalData)
            }
            quickActionButton(label: "My Favorites", icon: "heart") {
                coordinator.activeTab = .favorites
            }
            quickActionButton(label: "Notification", icon: "bell") {
                coordinator.profileStack.append(.notification)
            }
            
            Divider().customStroke(strokeSize: 0.15, strokeColor: .app)
                .padding(.horizontal)
                .padding(.vertical, 12)
        }
    }
    
    // MARK: - Settings Section
    var settingsSection: some View {
        VStack {
            quickActionButton(label: "Settings", icon: "gear") {
                coordinator.profileStack.append(.settings)
            }
            quickActionButton(label: "Request Account Deletion", icon: "trash") {
                coordinator.profileStack.append(.requestAccountDeletion)
            }
        }
    }
    
    // MARK: - Log Out Button
    var logOutButton: some View {
        Button {
            if !KeychainHelper.deleteToken() {
                print("Don't delete Token")
            }
            appState.checkAuthentication()
        } label: {
            Text("Log Out")
                .foregroundColor(.letter)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background {
                    Capsule()
                        .fill(Color.app)
                }
        }
        .padding(.top)
    }
    
    // MARK: - Helper Buttons
    func orderButton(title: String, _ action: @escaping () -> Void) -> some View {
        Button(title) {
            action()
        }
        .font(.callout.bold())
        .capsuleButtonStyle()
    }
    
    func quickActionButton(label: String, icon: String, _ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Label(label, systemImage: icon)
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
        ProfileView()
            .environmentObject(MainTabCoordinator())
            .environmentObject(AppState())
    }
    .tint(.app)
}
