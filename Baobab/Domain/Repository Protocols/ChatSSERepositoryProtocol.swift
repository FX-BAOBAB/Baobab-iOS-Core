//
//  ChatSSERepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Foundation

protocol ChatSSERepositoryProtocol {
    func startStreaming(articleId: String) -> AnyPublisher<[ChatMessage], any Error>
    func startStreaming(chatRoomId: String) -> AnyPublisher<[ChatMessage], any Error>
}
