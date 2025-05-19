//
//  ChatRoomViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 4/10/25.
//

import Combine
import RxRelay
import Factory
import Foundation
import os

@MainActor
final class ChatRoomViewModel {
    @Injected(\.connectChatRoomUseCase) private var connectChatRoomUseCase
    @Injected(\.sendMessageUseCase) private var sendMessageUseCase
    @Injected(\.chatRoomRepository) private var chatRoomRepository
    let messages: BehaviorRelay<[ChatMessage]> = .init(value: [])
    private var receivedMessages: [ChatMessage] = []
    private var pendingMessages: [ChatMessage] = []
    private var cancellables: Set<AnyCancellable> = []
    private let articleId: String
    private let chatRoomId: String
    private let logger: Logger = Logger()
    private(set) var task: Task<Void, Never>?
    
    init(articleId: String, chatRoomId: String) {
        self.articleId = articleId
        self.chatRoomId = chatRoomId
    }
}

extension ChatRoomViewModel {
    func connect() {
        connectChatRoomUseCase.execute(chatRoomId: chatRoomId, articleId: articleId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("ChatRoomViewModel.connect() Stream Finished")
                case .failure(let error):
                    self?.logger.error("ChatRoomViewModel.connect() error: \(error)")
                    self?.reconnect()
                }
            }, receiveValue: { [weak self] in
                guard let self else { return }
                
                receivedMessages = attach(newMessages: $0, to: receivedMessages)
                messages.accept(receivedMessages + pendingMessages)
            })
            .store(in: &cancellables)
    }
    
    private func reconnect() {
        connectChatRoomUseCase.execute(
            chatRoomId: chatRoomId,
            articleId: articleId,
            shouldLoadPreviousMessages: false,
            initialValue: messages.value
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                self?.logger.info("ChatRoomViewModel.reconnect() Stream Finished")
            case .failure(let error):
                self?.logger.error("ChatRoomViewModel.reconnect() error: \(error)")
                self?.reconnect()
            }
        }, receiveValue: { [weak self] in
            guard let self else { return }
            
            receivedMessages = attach(newMessages: $0, to: receivedMessages)
            messages.accept(receivedMessages + pendingMessages)
        })
        .store(in: &cancellables)
    }
    
    private func attach(newMessages: [ChatMessage], to messages: [ChatMessage]) -> [ChatMessage] {
        var messages = messages
        var newMessages = newMessages
        
        for i in newMessages.indices {
            if let lastMessage = messages.last {
                if lastMessage.nickname == newMessages[i].nickname {
                    messages.append(newMessages[i])
                } else {
                    newMessages[i].messageType = .textWithProfile
                    messages.append(newMessages[i])
                }
            } else {
                newMessages[i].messageType = .textWithProfile
                messages.append(newMessages[i])
            }
        }
        
        return messages
    }
}

extension ChatRoomViewModel {
    func send(message: String) {
        sendMessageUseCase.execute(message: message, to: chatRoomId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] message in
                guard let self else { return }
                
                if pendingMessages.contains(id: message.0) {
                    let idx = pendingMessages.firstIndex { $0.id == message.0 }
                    pendingMessages.remove(at: idx!)
                    receivedMessages.append(message.1)
                } else {
                    pendingMessages.append(message.1)
                }
                
                messages.accept(receivedMessages + pendingMessages)
            })
            .store(in: &cancellables)
    }
}

extension ChatRoomViewModel {
    func exit() {
        Task {
            let result = await chatRoomRepository.exitChatRoom(of: chatRoomId)
            switch result {
            case .success:
                logger.info("ChatRoomViewModel.disconnect() success")
            case .failure(let error):
                logger.error("ChatRoomViewModel.discoonect() error: \(error)")
            }
        }
    }
}

fileprivate extension Array where Element == ChatMessage {
    func contains(id: String) -> Bool {
        for i in self.indices where self[i].id == id {
            return true
        }
        
        return false
    }
}
