//
//  ChatRoomsResponseDTO.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Foundation

// MARK: - ChatRoomsResponseDTO
struct ChatRoomsResponseDTO: Decodable {
    let result: RequestResult
    let body: [ChatRoomsResponseBody]
}

// MARK: - Body
struct ChatRoomsResponseBody: Decodable {
    let chatRoomID, title, articleID, thumbnailURL: String
    let lastChatAt: String

    enum CodingKeys: String, CodingKey {
        case chatRoomID = "chatRoomId"
        case title
        case articleID = "articleId"
        case thumbnailURL = "thumbnailUrl"
        case lastChatAt
    }
}
