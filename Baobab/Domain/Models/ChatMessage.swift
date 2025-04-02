//
//  ChatMessage.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Foundation

struct ChatMessage {
    let id, message: String
    let messageType: MessageType
    let sentAt: String
    let isRead: Bool
    let chatRoomId: String
}

enum MessageType: String {
    case text = "TEXT"
}
