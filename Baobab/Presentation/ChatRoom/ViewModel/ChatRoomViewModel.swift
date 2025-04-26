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
    @Injected(\.chatUseCase) private var usecase: ChatUseCaseProtocol
    let messages: BehaviorRelay<[ChatMessage]> = .init(value: [])
    private var cancellables: Set<AnyCancellable> = []
    private let articleId: String
    private let chatRoomId: String
    private let logger: Logger = Logger()
    var task: Task<Void, Never>?
    
    init(articleId: String, chatRoomId: String) {
        self.articleId = articleId
        self.chatRoomId = chatRoomId
    }
    
    func connect() {
        usecase.connect(to: chatRoomId, with: articleId)
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
                self?.messages.accept($0)
            })
            .store(in: &cancellables)
    }
    
    private func reconnect() {
        usecase.reconnect(with: articleId, initialValue: messages.value)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("ChatRoomViewModel.reconnect() Stream Finished")
                case .failure(let error):
                    self?.logger.error("ChatRoomViewModel.reconnect() error: \(error)")
                    self?.reconnect()
                }
            }, receiveValue: { [weak self] in
                self?.messages.accept($0)
            })
            .store(in: &cancellables)
    }
    
    func exit() {
        Task {
            let result = await usecase.exit(chatRoomId: chatRoomId)
            switch result {
            case .success:
                logger.info("ChatRoomViewModel.disconnect() success")
            case .failure(let error):
                logger.error("ChatRoomViewModel.discoonect() error: \(error)")
            }
        }
    }
}
