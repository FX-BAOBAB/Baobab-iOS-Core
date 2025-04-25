//
//  ChatMessagingRepository.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Factory
import Foundation

final class ChatMessagingRepository: ChatMessagingRepositoryProtocol, DateAndTimeProvidable {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSourceProtocol
    
    func sendMessage(_ params: [String: Any]) async -> Result<Void, any Error> {
        guard let endPoint = Bundle.main.chatEndPoint else {
            return .failure(NetworkError.invalidEndpoint)
        }
        
        do {
            let dto = try await dataSource.post(to: endPoint + "/message", params: params, decoding: PostResponseDTO.self)
            if dto.result.resultCode == 200 {
                return .success(())
            }
            return .failure(NetworkError.serverError(code: dto.result.resultCode, message: dto.result.resultMessage))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchMessages(from chatRoomId: String) -> AnyPublisher<[ChatMessage], any Error> {
        guard let endPoint = Bundle.main.chatEndPoint else {
            return Fail(error: NetworkError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        return dataSource.get(to: endPoint + "/messages?chatRoomId=\(chatRoomId)", decoding: ChatMessagesResponseDTO.self)
            .compactMap { [weak self] dto in
                self?.createChatMessages(dto)
            }
            .eraseToAnyPublisher()
    }
    
    private func createChatMessages(_ dto: ChatMessagesResponseDTO) -> [ChatMessage] {
        dto.body.map {
            ChatMessage(
                id: $0.id,
                message: $0.message,
                messageType: MessageType(rawValue: $0.messageType),
                sentDate: getDate(from: $0.sentAt),
                sentTime: getTime(from: $0.sentAt),
                isRead: $0.isRead,
                chatRoomId: $0.chatRoomID,
                nickname: $0.nickname,
                profileImageURL: $0.profileImageURL,
                isMine: $0.isMine
            )
        }
    }
}
