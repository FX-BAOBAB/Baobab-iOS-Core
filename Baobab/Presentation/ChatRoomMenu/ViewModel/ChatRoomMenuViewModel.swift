//
//  ChatRoomMenuViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 4/9/25.
//

import Combine
import Factory
import Foundation

@MainActor
final class ChatRoomMenuViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Injected(\.chatRoomRepository) private var repository: ChatRoomRepositoryProtocol
    var task: Task<Void, Never>?
    var alertMessage: String?
}
