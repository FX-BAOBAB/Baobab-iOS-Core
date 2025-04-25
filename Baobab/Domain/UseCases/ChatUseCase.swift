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
    func exit(chatRoomId: String) async -> Result<Void, any Error>
}

final class ChatUseCase: ChatUseCaseProtocol {
    @Injected(\.chatMessagingRepository) private var chatMessagingRepository: ChatMessagingRepositoryProtocol
    @Injected(\.chatSSERepository) private var chatSSERepository: ChatSSERepositoryProtocol
    @Injected(\.chatRoomRepository) private var chatRoomRepository: ChatRoomRepositoryProtocol
    
    func connect(from articleId: String) -> AnyPublisher<ChatMessage, any Error> {
        return chatSSERepository.startStreaming(from: articleId)
    }
    
    func fetchMessages(from chatRoomId: String) async -> Result<[ChatMessage], any Error> {
        do {
            var messages = try await chatMessagingRepository.fetchMessages(from: chatRoomId)
            var processedMessage = [ChatMessage]()
            for i in messages.indices {
                if let lastMessage = processedMessage.last {
                    if lastMessage.nickname == messages[i].nickname {
                        processedMessage.append(messages[i])
                    } else {
                        messages[i].messageType = .textWithProfile
                        processedMessage.append(messages[i])
                    }
                } else {
                    messages[i].messageType = .textWithProfile
                    processedMessage.append(messages[i])
                }
            }
            
            return .success(processedMessage)
        } catch {
            return .failure(error)
        }
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
    
    func exit(chatRoomId: String) async -> Result<Void, any Error> {
        return await chatRoomRepository.exitChatRoom(of: chatRoomId)
    }
}
