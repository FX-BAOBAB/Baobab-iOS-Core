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
    
    init(viewModel: ChatRoomMenuViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
        ChatRoomMenu(viewModel: ChatRoomMenuViewModel(chatRoomId: "12345"))
    }
}
