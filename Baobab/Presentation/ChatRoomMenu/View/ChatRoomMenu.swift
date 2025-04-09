//
//  ChatRoomMenu.swift
//  Baobab
//
//  Created by 이정훈 on 4/9/25.
//

import SwiftUI

struct ChatRoomMenu: View {
    @StateObject private var viewModel: ChatRoomMenuViewModel
    @Environment(\.dismiss) private var dismiss
    private let chatRoomId: String
    
    init(
        viewModel: ChatRoomMenuViewModel,
        chatRoomId: String
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.chatRoomId = chatRoomId
    }
    
    var body: some View {
        ZStack {
            List {
                Button {
                    
                } label: {
                    Text("채팅방 나가기")
                        .foregroundStyle(.red)
                }
                .listRowBackground(Color.white)
            }
            
            if viewModel.isLoading {
                SpinningIndicator()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatRoomMenu(viewModel: ChatRoomMenuViewModel(), chatRoomId: "12345")
    }
}
