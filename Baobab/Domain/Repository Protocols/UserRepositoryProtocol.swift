//
//  UserRepository.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func signup(params: [String: Any]) async -> Result<Void, Error>
}
