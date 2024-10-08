//
//  EmojiPicker.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 07.10.2024.
//

import SwiftUI

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    
    let emojis: [String]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button(action: {
                            selectedEmoji = emoji
                        }) {
                            Text(emoji)
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(selectedEmoji == emoji ? Color.gray.opacity(0.3) : Color.clear)
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    init(selectedEmoji: Binding<String>, from start: Int = 0x1F600, to end: Int = 0x1F64F) {
        self._selectedEmoji = selectedEmoji
        self.emojis = EmojiPicker.getEmojis(from: start, to: end)
    }
    
    private static func getEmojis(from start: Int, to end: Int) -> [String] {
        var emojis = [String]()
        
        for unicodeValue in start...end {
            if let scalar = UnicodeScalar(unicodeValue) {
                if scalar.properties.isEmoji {
                    let emoji = String(scalar)
                    emojis.append(emoji)
                }
            }
        }
        
        return emojis
    }
}
