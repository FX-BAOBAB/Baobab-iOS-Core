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

final class ChatRoomViewModel {
    @Injected(\.chatUseCase) private var usecase: ChatUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    private let articleId: String
    private let chatRoomId: String
    
    init(articleId: String, chatRoomId: String) {
        self.articleId = articleId
        self.chatRoomId = chatRoomId
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
