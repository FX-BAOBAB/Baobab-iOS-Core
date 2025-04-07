//
//  ChatRoomRepository.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Factory
import Foundation

final class ChatRoomRepository: ChatRoomRepositoryProtocol {
    @Injected(\.remoteDataSource) private var remoteDataSource: RemoteDataSourceProtocol
    
    func fetchChatRooms() async -> Result<[ChatRoom], any Error> {
        guard let endpoint = Bundle.main.chatEndPoint else {
            return .failure(NetworkError.invalidEndpoint)
        }
        
        do {
            let dto = try await remoteDataSource.get(to: endpoint + "/rooms", decoding: ChatRoomsResponseDTO.self)
            if dto.result.resultCode == 200 {
                let chatRooms = createChatRooms(from: dto)
                return .success(chatRooms)
            }
            
            return .failure(NetworkError.serverError(code: dto.result.resultCode, message: dto.result.resultMessage))
        } catch {
            return .failure(error)
        }
    }
    
    private func createChatRooms(from dto: ChatRoomsResponseDTO) -> [ChatRoom] {
        dto.body.map {
            ChatRoom(
                id: $0.chatRoomID,
                title: $0.title,
                articleId: $0.articleID,
                thumbnailURL: URL(string: $0.thumbnailURL),
                lastChatAt: $0.lastChatAt.toDate?.dotFormattedString
            )
        }
    }
}
