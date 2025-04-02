//
//  ChatSSEManager.swift
//  Baobab
//
//  Created by 이정훈 on 4/1/25.
//

import Alamofire
import Combine

final class ChatSSEManager {
    let chatroomIdPublisher: PassthroughSubject = PassthroughSubject<String?, Never>()
    static let shared: ChatSSEManager = .init()
    private var streamRequest: DataStreamRequest?
    
    private init() {}
    
    func connect(to url: String) -> AnyPublisher<String?, Never> {
        AF.streamRequest(url, interceptor: TokenInterceptor.shared)
            .onHTTPResponse { [weak self] response in
                self?.chatroomIdPublisher.send(response.headers.dictionary["chatroomidheader"])
                self?.chatroomIdPublisher.send(completion: .finished)
                print(response.headers.dictionary["chatroomidheader"])
            }
            .publishStream(using: .string)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
