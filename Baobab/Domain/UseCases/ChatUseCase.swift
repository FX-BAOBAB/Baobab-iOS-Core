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
    func connect(to chatRoomId: String, with articleId: String) -> AnyPublisher<[ChatMessage], any Error>
    func send(message: String, to chatRoomId: String) async -> Result<Void, any Error>
    func exit(chatRoomId: String) async -> Result<Void, any Error>
}

final class ChatUseCase: ChatUseCaseProtocol {
    @Injected(\.chatMessagingRepository) private var chatMessagingRepository: ChatMessagingRepositoryProtocol
    @Injected(\.chatSSERepository) private var chatSSERepository: ChatSSERepositoryProtocol
    @Injected(\.chatRoomRepository) private var chatRoomRepository: ChatRoomRepositoryProtocol
    
    func connect(to chatRoomId: String, with articleId: String) -> AnyPublisher<[ChatMessage], any Error> {
        return chatMessagingRepository.fetchMessages(from: chatRoomId)
            .merge(with: chatSSERepository.startStreaming(from: articleId))
            .scan([]) { (messages, newMessages) in
                var newMessages = newMessages
                var messages = messages
                for i in newMessages.indices {
                    if let lastMessage = messages.last {
                        if lastMessage.nickname == newMessages[i].nickname {
                            messages.append(newMessages[i])
                        } else {
                            newMessages[i].messageType = .textWithProfile
                            messages.append(newMessages[i])
                        }
                    } else {
                        newMessages[i].messageType = .textWithProfile
                        messages.append(newMessages[i])
                    }
                }
                
                return messages
            }
            .eraseToAnyPublisher()
        
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
