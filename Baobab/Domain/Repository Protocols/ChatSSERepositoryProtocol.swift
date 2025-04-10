//
//  ChatSSERepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Foundation

protocol ChatSSERepositoryProtocol {
    func startStreaming(from articleId: String) -> AnyPublisher<ChatMessage, any Error>
}
