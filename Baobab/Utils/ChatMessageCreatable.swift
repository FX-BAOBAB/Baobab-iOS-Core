//
//  ChatMessageCreatable.swift
//  Baobab
//
//  Created by 이정훈 on 5/8/25.
//

import Foundation

protocol ChatMessageCreatable: DateAndTimeProvidable {
    func createChatMessage(_ body: ChatMessageResponseBody) -> ChatMessage
}

extension ChatMessageCreatable {
    func createChatMessage(_ body: ChatMessageResponseBody) -> ChatMessage {
        ChatMessage(
            id: body.id,
            message: body.message,
            messageType: MessageType(rawValue: body.messageType),
            sentDate: getDate(from: body.sentAt),
            sentTime: getTime(from: body.sentAt),
            isRead: body.isRead,
            chatRoomId: body.chatRoomID,
            nickname: body.nickname,
            profileImageURL: body.profileImageURL,
            isMine: body.isMine,
            isLoading: false
        )
    }
    
    func createMockChatMessage(id: String, message: String) -> ChatMessage {
        ChatMessage(
            id: id,
            message: message,
            messageType: MessageType.text,
            sentDate: "",
            sentTime: "",
            isRead: false,
            chatRoomId: "",
            nickname: "",
            profileImageURL: "",
            isMine: true,
            isLoading: true
        )
    }
}
