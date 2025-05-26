//
//  ConnectChatRoomUseCase.swift
//  Baobab
//
//  Created by 이정훈 on 5/8/25.
//

import Combine
import Factory
import Foundation

protocol ConnectChatRoomUseCaseProtocol {
    func execute(
        chatRoomId: String,
        articleId: String,
        shouldLoadPreviousMessages: Bool,
        initialValue: [ChatMessage]
    ) -> AnyPublisher<[ChatMessage], any Error>
}

extension ConnectChatRoomUseCaseProtocol {
    func execute(
        chatRoomId: String,
        articleId: String,
        shouldLoadPreviousMessages: Bool = true,
        initialValue: [ChatMessage] = []
    ) -> AnyPublisher<[ChatMessage], any Error> {
        self.execute(
            chatRoomId: chatRoomId,
            articleId: articleId,
            shouldLoadPreviousMessages: shouldLoadPreviousMessages,
            initialValue: initialValue
        )
    }
}

final class ConnectChatRoomUseCaseImpl: ConnectChatRoomUseCaseProtocol {
    @Injected(\.chatMessageRepository) private var chatMessagingRepository: ChatMessageRepositoryProtocol
    @Injected(\.chatSSERepository) private var chatSSERepository: ChatSSERepositoryProtocol
    
    func execute(
        chatRoomId: String,
        articleId: String,
        shouldLoadPreviousMessages: Bool = true,
        initialValue: [ChatMessage] = []
    ) -> AnyPublisher<[ChatMessage], any Error> {
        return Deferred { [weak self] in
            guard let self else {
                return Fail<[ChatMessage], any Error>(error: NSError(domain: "SelfDeallocated", code: -1))
                    .eraseToAnyPublisher()
            }
            
            if shouldLoadPreviousMessages {
                return self.chatMessagingRepository.fetchMessages(from: chatRoomId)
            }
            
            return Empty<[ChatMessage], any Error>()
                .eraseToAnyPublisher()
        }
        .merge(with: chatSSERepository.startStreaming(articleId: articleId))
        .eraseToAnyPublisher()
    }
}
