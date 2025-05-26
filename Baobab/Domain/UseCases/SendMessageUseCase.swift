//
//  SendMessageUseCase.swift
//  Baobab
//
//  Created by 이정훈 on 5/8/25.
//

import Combine
import Factory
import Foundation

protocol SendMessageUseCaseProtocol {
    func execute(message: String, to chatRoomId: String) -> AnyPublisher<(String, ChatMessage), any Error>
}

final class SendMessageUseCaseImpl: SendMessageUseCaseProtocol, ChatMessageCreatable {
    @Injected(\.chatMessageRepository) private var repository: ChatMessageRepositoryProtocol
    
    func execute(message: String, to chatRoomId: String) -> AnyPublisher<(String, ChatMessage), any Error> {
        let params = createParams(message: message, chatRoomId: chatRoomId)
        let id = UUID().uuidString
        
        return repository.sendMessage(params)
            .map {
                (id, $0)
            }
            .prepend((id, createMockChatMessage(id: id, message: message)))
            .eraseToAnyPublisher()
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
