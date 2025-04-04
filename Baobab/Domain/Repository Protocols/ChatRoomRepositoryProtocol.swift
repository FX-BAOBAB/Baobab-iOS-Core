//
//  ChatRoomRepository.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Foundation

protocol ChatRoomRepositoryProtocol {
    func fetchChatRooms() async -> Result<[ChatRoom], any Error>
}
