//
//  ChatRoom.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Foundation

struct ChatRoom: Identifiable {
    let id, title, articleId: String
    let thumbnailURL: URL?
    let lastChatAt: String?
}
