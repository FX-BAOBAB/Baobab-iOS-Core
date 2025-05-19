//
//  ChatMessagingRepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Foundation

protocol ChatMessagingRepositoryProtocol {
    func sendMessage(_ params: [String: Any]) -> AnyPublisher<ChatMessage, any Error>
    func fetchMessages(from chatRoomId: String) -> AnyPublisher<[ChatMessage], any Error>
}
