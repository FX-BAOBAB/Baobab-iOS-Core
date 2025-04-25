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
    
    func fetchMessages() {
        task = Task {
            let results = await usecase.fetchMessages(from: chatRoomId)
            guard !Task.isCancelled else { return }
            
            switch results {
            case .success(let messages):
                self.messages.accept(messages)
            case .failure(let error):
                logger.error("ChatRoomViewModel.fetchMessages() error : \(error)")
            }
        }
    }
    
    func connect() {
        usecase.connect(from: articleId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("ChatRoomViewModel.connect() Stream Finished")
                case .failure(let error):
                    self?.logger.error("ChatRoomViewModel.connect() error: \(error)")
                    self?.connect()
                }
            }, receiveValue: { [weak self] in
                guard let self else { return }
                
                let messages = self.messages.value
                self.messages.accept(messages + [$0])
            })
            .store(in: &cancellables)
    }
    
    func disconnect() {
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
