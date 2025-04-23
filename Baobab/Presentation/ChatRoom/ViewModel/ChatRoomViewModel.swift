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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Stream Finished")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
    }
}
