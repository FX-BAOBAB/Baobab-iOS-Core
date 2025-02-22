//
//  Factory+ViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 1/30/25.
//

import Factory

extension Container {
    //MARK: - DataSource
    var remoteDataSource: Factory<RemoteDatasourceProtocol> {
        Factory(self) {
            RemoteDataSource.shared
        }
    }
    
    //MARK: - Repository
    var authRepository: Factory<AuthRepositoryProtocol> {
        Factory(self) {
            AuthRepository()
        }
    }
    
    var tokenRepository: Factory<TokenRepositoryProtocol> {
        Factory(self) {
            TokenRepository()
        }
    }
    
    //MARK: - UseCase
    var loginUseCase: Factory<LoginUseCaseProtocol> {
        Factory(self) {
            LoginUseCase()
        }
    }
}
