//
//  ChatMessagingUseCase.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Factory
import Foundation

protocol ChatUseCaseProtocol {
    func connect(from url: String) -> AnyPublisher<ChatMessage, any Error>
    func fetchMessages(from chatRoomId: String) async -> Result<[ChatMessage], any Error>
    func send(message: String, to chatRoomId: String) async -> Result<Void, any Error>
}

final class ChatUseCase: ChatUseCaseProtocol {
    @Injected(\.chatMessagingRepository) private var chatMessagingRepository: ChatMessagingRepositoryProtocol
    @Injected(\.chatSSERepository) private var chatSSERepository: ChatSSERepositoryProtocol
    
    func connect(from articleId: String) -> AnyPublisher<ChatMessage, any Error> {
        return chatSSERepository.startStreaming(from: articleId)
    }
    
    func fetchMessages(from chatRoomId: String) async -> Result<[ChatMessage], any Error> {
        return await chatMessagingRepository.fetchMessages(from: chatRoomId)
    }
    
    func send(message: String, to chatRoomId: String) async -> Result<Void, any Error> {
        let params = createParams(message: message, chatRoomId: chatRoomId)
        return await chatMessagingRepository.sendMessage(params)
    }
    
    private func createParams(message: String, chatRoomId: String) -> [String: Any] {
        var params = Dictionary<String, Any>.baseParam
        params["body"] = [
            "message": message,
            "messageType": MessageType.text.rawValue,
            "chatRoomId": chatRoomId
        ]
        
        return params
    }
}
