//
//  PersonalDataView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import SwiftUI

struct PersonalDataView: View {
    @StateObject private var viewModel = PersonalDataViewModel()
    @EnvironmentObject var coordinator: MainTabCoordinator
        
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            if let user = viewModel.user {
                ScrollView {
                    
                    Button {
                        viewModel.isEmojiPicker.toggle()
                    } label: {
                        Text(viewModel.emoji)
                            .font(.system(size: 50))
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundStyle(.app)
                            }
                    }
                    
                    Text("Edit your Emoji")
                        .font(.callout)
                        .foregroundStyle(.app)
                    
                    Text("Basic Information")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .padding()
                    
                    quickActionButton(title: "Username", subtitle: String(user.username.prefix(15))) {
                        coordinator.profileStack.append(.editPersonalData(.userName))
                    }
                    
                    quickActionButton(title: "First Name", subtitle: user.name ?? "Empty") {
                        coordinator.profileStack.append(.editPersonalData(.firstName))
                    }
                    
                    quickActionButton(title: "Last Name", subtitle: user.lastname ?? "Empty") {
                        coordinator.profileStack.append(.editPersonalData(.lastName))
                    }
                    
                    quickActionButton(title: "Phone number", subtitle: user.phoneNumber ?? "Empty") {
                        coordinator.profileStack.append(.editPersonalData(.phoneNumber))
                    }
                    
                    quickActionButton(title: "E-mail address", subtitle: user.email) {
                        coordinator.profileStack.append(.editPersonalData(.emailAdress))
                    }
                    
                    Spacer().padding(.bottom)
                }
                .refreshable {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await viewModel.reloadData()
                }
                .overlay(alignment: .bottom) {
                    if viewModel.isEmojiPicker {
                        VStack {
                            EmojiPicker(selectedEmoji: $viewModel.emoji)
                                .frame(height: 300)
                                .roundedButton(cornerRadius: 15)
                                .clipShape(.rect(cornerRadius: 15))
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom))
                    }
                }
                .animation(.linear, value: viewModel.isEmojiPicker)
            } else {
                VStack {
                    Image(systemName: "person.text.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .foregroundStyle(.app)
                        .opacity(0.8)
                    
                    Text("Personal data not found")
                        .font(.title2.bold())
                        .foregroundStyle(.letter)
                        .customStroke(strokeSize: 2, strokeColor: .app)
                }
            }
        }
        .navigationTitle("Personal Data")
        .task {
            await viewModel.reloadData()
        }
        .toolbar {
            if viewModel.isEmojiPicker {
                Button {
                    viewModel.isEmojiPicker = false
                } label: {
                    Circle()
                        .fill(.gray)
                        .frame(width: 30)
                        .opacity(0.3)
                        .overlay {
                            Image(systemName: "xmark")
                                .font(.caption.weight(.black))
                                .foregroundStyle(.customBackground)
                                .brightness(0.5)
                        }
                }
            }
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
    
    // MARK: - Helper Buttons
    func quickActionButton(title: String, subtitle: String, _ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack {
                    Text(title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.label)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.callout.bold())
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .padding()
            .roundedButton(cornerRadius: 15)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationView {
        PersonalDataView()
            .environmentObject(MainTabCoordinator())
    }
    .tint(.app)
}
