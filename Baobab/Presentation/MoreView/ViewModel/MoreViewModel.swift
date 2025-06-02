//
//  MoreViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 6/2/25.
//

import Combine
import Factory
import os

@MainActor
final class MoreViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    @Injected(\.userRepository) private var repository
    private var logger: Logger = Logger()
    
    func fetchUserInfo() async {
        let result = await repository.fetchUserInfo()
        
        guard !Task.isCancelled else { return }
        
        switch result {
        case .success(let userInfo):
            self.userInfo = userInfo
        case .failure(let error):
            logger.error("MoreViewModel.fetchUserInfo() error: \(error)")
        }
    }
}
