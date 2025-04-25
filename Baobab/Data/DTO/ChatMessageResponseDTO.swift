//
//  ChatMessageResponseDTO.swift
//  Baobab
//
//  Created by 이정훈 on 4/10/25.
//

import Foundation

// MARK: - ChatMessageResponseDTO
struct ChatMessageResponseDTO: Decodable {
    let id, senderID: String
    let receiverIDList: [String]
    let message, messageType, sentAt: String
    let isRead: Bool
    let chatRoomID, nickname: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "senderId"
        case receiverIDList = "receiverIdList"
        case message, messageType, sentAt, isRead
        case chatRoomID = "chatRoomId"
        case nickname
        case profileImageURL = "profileImageUrl"
    }
}
