//
//  ChatMessageRepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Foundation

protocol ChatMessageRepositoryProtocol {
    func sendMessage(_ params: [String: Any]) -> AnyPublisher<ChatMessage, any Error>
    func fetchMessages(from chatRoomId: String, before date: String?) -> AnyPublisher<[ChatMessage], any Error>
}

extension ChatMessageRepositoryProtocol {
    func fetchMessages(from chatRoomId: String, before date: String? = nil) -> AnyPublisher<[ChatMessage], any Error> {
        self.fetchMessages(from: chatRoomId, before: date)
    }
}
