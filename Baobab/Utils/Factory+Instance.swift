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
    var userRepository: Factory<UserRepositoryProtocol> {
        Factory(self) {
            UserRepository()
        }
    }
    
    var loginViewModel: Factory<LoginFormModel> {
        Factory(self) {
            LoginFormModel()
        }
    }
}
