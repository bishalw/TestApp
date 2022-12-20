//
//  EmojiKeyboard.swift
//  TestApp
//
//  Created by Bishalw on 10/13/22.
//

import Foundation
import SwiftUI


struct EmojiKey: View {
    let emoji: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.largeTitle)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmojiKeyboard: View {
    let action: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                EmojiKey(emoji: "👍") { self.action("👍") }
                EmojiKey(emoji: "👎") { self.action("👎") }
            }
            HStack(spacing: 0) {
                EmojiKey(emoji: "👌") { self.action("👌") }
                EmojiKey(emoji: "👋") { self.action("👋") }
            }
        }
        .padding()
    }
}

struct EmojiKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        EmojiKeyboard(action: { _ in })
    }
}

