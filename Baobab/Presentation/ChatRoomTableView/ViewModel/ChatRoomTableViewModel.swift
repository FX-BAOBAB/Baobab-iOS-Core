//
//  ChatRoomTableViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Factory
import RxRelay
import os

final class ChatRoomTableViewModel {
    let chatRooms: BehaviorRelay<[ChatRoom]> = .init(value: [])
    @Injected(\.chatRoomRepository) var repository: ChatRoomRepositoryProtocol
    var task: Task<Void, Never>?
    private let logger: Logger = Logger()
    
    func fetchChatRooms() {
        task = Task {
            let result = await repository.fetchChatRooms()
            
            guard !Task.isCancelled else { return }
            
            switch result {
            case let .success(chatRooms):
                self.chatRooms.accept(chatRooms)
            case let .failure(error):
                logger.error("ChatRoomTableViewModel.fetchChatRooms() : \(error.localizedDescription)")
            }
        }
    }
}
