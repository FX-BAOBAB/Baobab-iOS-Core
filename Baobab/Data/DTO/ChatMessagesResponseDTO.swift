//
//  ChatMessagesResponseDTO.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Foundation

// MARK: - ChatMessagesResponseDTO
struct ChatMessagesResponseDTO: Decodable {
    let result: RequestResult
    let body: [ChatMessagesResponseBody]
}
// MARK: - Body
struct ChatMessagesResponseBody: Decodable {
    let id, message, messageType, sentAt: String
    let isRead: Bool
    let chatRoomID, nickname, profileImageURL: String
    let isMine: Bool

    enum CodingKeys: String, CodingKey {
        case id, message, messageType, sentAt, isRead
        case chatRoomID = "chatRoomId"
        case nickname
        case profileImageURL = "profileImageUrl"
        case isMine
    }
}
