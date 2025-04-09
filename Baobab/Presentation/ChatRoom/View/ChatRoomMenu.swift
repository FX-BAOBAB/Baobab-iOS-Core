//
//  ChatRoomMenu.swift
//  Baobab
//
//  Created by 이정훈 on 4/9/25.
//

import SwiftUI

struct ChatRoomMenu: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Button {
                print("click")
            } label: {
                Text("채팅방 나가기")
                    .foregroundStyle(.red)
            }
            .listRowBackground(Color.white)
        }
    }
}

#Preview {
    NavigationStack {
        ChatRoomMenu()
    }
}
