//
//  EditPersonalDataView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 08.10.2024.
//

import SwiftUI

struct EditPersonalDataView: View {
    @StateObject private var viewModel: EditPersonalDataViewModel
    @FocusState private var focus: Bool
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            VStack {
                Text(viewModel.title)
                    .font(.title.weight(.semibold))
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    TextField("Enter", text: $viewModel.editField)
                        .focused($focus)
                        .padding(.leading)
                        .padding(.trailing, 5)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.editField = ""
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.border)
                            .frame(width: 30, height: 30)
                            .overlay {
                                Image(systemName: "xmark")
                                    .font(.body.weight(.black))
                                    .foregroundStyle(.customBackground)
                            }
                    }
                    .padding(.trailing, 10)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.errorField != nil ? .red : .gray, lineWidth: 0.7)
                }
                .padding(.horizontal)
                
                if let errorEmail = viewModel.errorField {
                    Text(errorEmail)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                }
                
                Spacer()
                
                Button {
                    focus = false
                    viewModel.updateField()
                } label: {
                    Text("Update")
                        .foregroundColor(.letter)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(Color.app)
                        }
                }
                .padding()
            }
            
            if viewModel.isSuccess {
                HStack {
                    Text("Saved")
                        .font(.title.bold())
                        .foregroundColor(.green)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 20)
                }
                .padding()
                .background {
                    Color.green
                        .clipShape(.rect(cornerRadius: 10))
                        .opacity(0.1)
                }
                .zIndex(1)
                .transition(.scale)
                .animation(.easeInOut(duration: 0.5), value: viewModel.isSuccess)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.reloadData()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("done") {
                    focus = false
                }
            }
        }
        .showProgressView(isLoading: viewModel.isLoading)
        .showErrorMessega(errorMessage: viewModel.errorMessage)
    }
    
    init(field: PersonalDataField) {
        _viewModel = StateObject(wrappedValue: EditPersonalDataViewModel(field: field))
    }
}

#Preview {
    EditPersonalDataView(field: .userName)
}
