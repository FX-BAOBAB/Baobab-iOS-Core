//
//  ChatSSERepository.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Foundation

final class ChatSSERepository: ChatSSERepositoryProtocol {
    func startStreaming(from articleId: String) -> AnyPublisher<String?, any Error> {
        guard let endPoint = Bundle.main.chatEndPoint else {
            return Fail(error: NetworkError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        return ChatSSEManager.shared.connect(to: endPoint + "/chat-room/\(articleId)")
            .map { $0 }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
