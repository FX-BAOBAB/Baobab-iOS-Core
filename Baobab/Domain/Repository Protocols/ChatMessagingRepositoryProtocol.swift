//
//  ChatMessagingRepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Foundation

protocol ChatMessagingRepositoryProtocol {
    func sendMessage(_ params: [String: Any]) async -> Result<Void, any Error>
    func fetchMessages(from chatRoomId: String) async -> Result<[ChatMessage], any Error>
}
