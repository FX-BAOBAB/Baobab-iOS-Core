//
//  Factory+ViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 1/30/25.
//

import Alamofire
import Factory

extension Container {
    //MARK: - DataSource
    var remoteDataSource: Factory<RemoteDataSourceProtocol> {
        Factory(self) {
            let dataSource = RemoteDataSource()
            let tokenInterceptor = TokenInterceptor(remoteDataSource: dataSource)
            dataSource.tokenInterceptor = tokenInterceptor
            
            return dataSource
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
