//
//  UserRepository.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Foundation

protocol AuthRepositoryProtocol {
    func signup(params: [String: Any]) async -> Result<Void, Error>
    func login(params: [String: Any]) async throws -> (accessToken: String, refreshToken: String)
}
