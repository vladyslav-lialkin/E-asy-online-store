//
//  ProductReviewView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 11.09.2024.
//

import SwiftUI

struct ProductReviewView: View {
    @ObservedObject var viewModel: ProductViewModel
    @FocusState var focus: Bool
        
    let product: Product
    let proxy: ScrollViewProxy
    
    var body: some View {
        VStack {
            Divider()
                .customStroke(strokeSize: 0.15, strokeColor: .app)
            
            Text("Review")
                .customStroke(strokeSize: 1.6, strokeColor: .app)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.letter)
            
            VStack {
                Text("Your review")
                    .font(.callout)
                    .foregroundStyle(.letter)
                    .customStroke(strokeSize: 1, strokeColor: .app)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Group {
                    if #available(iOS 16.0, *) {
                        TextField("Enter review", text: $viewModel.review, axis: .vertical)
                    } else {
                        TextField("Enter review", text: $viewModel.review)
                    }
                }
                .focused($focus)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, -5)
                
                HStack(spacing: 5) {
                    ForEach(1...5, id: \.self) { value in
                        Button {
                            viewModel.rating = value
                        } label: {
                            if value <= viewModel.rating {
                                Image(systemName: "star.fill")
                            } else {
                                Image(systemName: "star")
                                    .background(.letter)
                                    .mask {
                                        Image(systemName: "star.fill")
                                    }
                            }
                        }
                    }
                    .foregroundStyle(.app)
                    .animation(.easeInOut, value: viewModel.rating)
                    
                    Spacer()
                    
                    Button {
                        focus = false
                        viewModel.addReview()
                    } label: {
                        Text("Send")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.letter)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.app)
                                    .padding(.vertical, -2)
                                    .padding(.horizontal, -3)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.app, lineWidth: 1.0)
            }
            
            Spacer()
                .frame(height: 10)
                .id("Identifier")
                .onChange(of: focus) { value in
                    if value {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.linear) {
                                proxy.scrollTo("Identifier", anchor: .bottom)
                            }
                        }
                    }
                }
            
            if viewModel.reviews.isEmpty {
                Text("No reviews")
                    .customStroke(strokeSize: 1.2, strokeColor: .app)
                    .foregroundStyle(.letter)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, -5)
            } else {
                ForEach(viewModel.reviews) { review in
                    VStack {
                        Text(review.autherName.prefix(20))
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                        
                        Text(review.comment)
                            .customStroke(strokeSize: 1.2, strokeColor: .app)
                            .foregroundStyle(.letter)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, -5)
                        
                        HStack(spacing: 5) {
                            ForEach(1...5, id: \.self) { value in
                                if value <= review.rating {
                                    Image(systemName: "star.fill")
                                } else {
                                    Image(systemName: "star")
                                        .background(.letter)
                                        .mask {
                                            Image(systemName: "star.fill")
                                        }
                                }
                            }
                            .foregroundStyle(.app)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.vertical, 10)
                    
                    viewModel.reviews.last?.id == review.id ? nil : Divider()
                }
            }
            
            Spacer()
                .frame(height: 30)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("done") {
                    focus = false
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ProductView(id: UUID(uuidString: "E0233890-71C4-4FF3-94C0-12CBB208BF3E")!)
    }
}
