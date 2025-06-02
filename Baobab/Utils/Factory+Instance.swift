//
//  Factory+ViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 1/30/25.
//

import Alamofire
import Factory

extension Container {
    //MARK: - Session
    var session: Factory<Session> {
        Factory(self) {
            return Session.default
        }
    }
    
    //MARK: - DataSource
    var remoteDataSource: Factory<RemoteDataSourceProtocol> {
        Factory(self) {
            return RemoteDataSource()
        }
    }
    
    //MARK: - Repository
    var authRepository: Factory<AuthRepositoryProtocol> {
        Factory(self) {
            AuthRepository()
        }
    }
    
    var tradeArticleRepository: Factory<TradeArticleRepositoryProtocol> {
        Factory(self) {
            TradeArticleRepository()
        }
    }
    
    var fileDownloadRepository: Factory<FileDownloadRepositoryProtocol> {
        Factory(self) {
            FileDownloadRepository()
        }
    }
    
    var chatMessageRepository: Factory<ChatMessageRepositoryProtocol> {
        Factory(self) {
            ChatMessageRepository()
        }
    }
    
    var chatSSERepository: Factory<ChatSSERepositoryProtocol> {
        Factory(self) {
            ChatSSERepository()
        }
    }
    
    var chatRoomRepository: Factory<ChatRoomRepositoryProtocol> {
        Factory(self) {
            ChatRoomRepository()
        }
    }
    
    var userRepository: Factory<UserRepositoryProtocol> {
        Factory(self) {
            UserRepository()
        }
    }
    
    //MARK: - UseCase
    var loginUseCase: Factory<LoginUseCaseProtocol> {
        Factory(self) {
            LoginUseCase()
        }
    }
    
    var fileDownloadUseCase: Factory<FileDownloadUseCaseProtocol> {
        Factory(self) {
            FileDownloadUseCase()
        }
    }
    
    var connectChatRoomUseCase: Factory<ConnectChatRoomUseCaseProtocol> {
        Factory(self) {
            ConnectChatRoomUseCaseImpl()
        }
    }
    
    var sendMessageUseCase: Factory<SendMessageUseCaseProtocol> {
        Factory(self) {
            SendMessageUseCaseImpl()
        }
    }
}
