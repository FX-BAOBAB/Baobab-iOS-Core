//
//  ChatSSERepository.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Factory
import Foundation

final class ChatSSERepository: ChatSSERepositoryProtocol, DateAndTimeProvidable {
    @Injected(\.remoteDataSource) private var remoteDataSource: RemoteDataSourceProtocol
    
    func startStreaming(articleId: String) -> AnyPublisher<[ChatMessage], any Error> {
        guard let endPoint = Bundle.main.chatEndPoint else {
            return Fail(error: NetworkError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        return remoteDataSource.connectSSE(from: endPoint + "/chat-room?articleId=\(articleId)", decoding: ChatMessageResponseDTO.self)
            .compactMap { [weak self] in
                let message = self?.createChatMessage($0)
                guard let message else { return nil }
                
                return [message]
            }
            .eraseToAnyPublisher()
    }
    
    func startStreaming(chatRoomId: String) -> AnyPublisher<[ChatMessage], any Error> {
        guard let endPoint = Bundle.main.chatEndPoint else {
            return Fail(error: NetworkError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        return remoteDataSource.connectSSE(from: endPoint + "/chat-room?chatRoomId=\(chatRoomId)", decoding: ChatMessageResponseDTO.self)
            .compactMap { [weak self] in
                let message = self?.createChatMessage($0)
                guard let message else { return nil }
                
                return [message]
            }
            .eraseToAnyPublisher()
    }
    
    private func createChatMessage(_ dto: ChatMessageResponseDTO) -> ChatMessage {
        ChatMessage(
            id: dto.id,
            message: dto.message,
            messageType: MessageType(rawValue: dto.messageType),
            sentDate: getDate(from: dto.sentAt),
            sentTime: getTime(from: dto.sentAt),
            isRead: dto.isRead,
            chatRoomId: dto.chatRoomID,
            nickname: dto.nickname,
            profileImageURL: dto.profileImageURL,
            isMine: false
        )
    }
}
