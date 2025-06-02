//
//  ChatMessageRepository.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Combine
import Factory
import Foundation

final class ChatMessageRepository: ChatMessageRepositoryProtocol, ChatMessageCreatable {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSourceProtocol
    
    func sendMessage(_ params: [String: Any]) -> AnyPublisher<ChatMessage, any Error> {
        return Future { [weak self] promise in
            guard let endPoint = Bundle.main.chatEndPoint else {
                promise(.failure(NetworkError.invalidEndpoint))
                return
            }
            
            guard let self else {
                promise(.failure(NSError(domain: "SelfDeallocated", code: -1)))
                return
            }
            
            Task {
                do {
                    let dto = try await self.dataSource.post(to: endPoint + "/message", params: params, decoding: SentMessageResponseDTO.self)
                    if dto.result.resultCode == 200 {
                        promise(.success(self.createChatMessage(dto.body)))
                    }
                    
                    promise(.failure(NetworkError.serverError(code: dto.result.resultCode, message: dto.result.resultMessage)))
                } catch {
                    return promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchMessages(from chatRoomId: String, before date: String?) -> AnyPublisher<[ChatMessage], any Error> {
        guard var endPoint = Bundle.main.chatEndPoint else {
            return Fail(error: NetworkError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        endPoint += "/messages?chatRoomId=\(chatRoomId)"
        
        if let date = date {
            endPoint += "&sentAt=\(date)"
        }
        
        return dataSource.send(endPoint, method: .get, decoding: ChatMessagesResponseDTO.self)
            .compactMap { [weak self] dto in
                dto.body.compactMap {
                    self?.createChatMessage($0)
                }
            }
            .eraseToAnyPublisher()
    }
}
