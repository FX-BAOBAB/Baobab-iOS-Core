//
//  TokenRepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 2/22/25.
//

import Foundation

protocol TokenRepositoryProtocol {
    @discardableResult
    func save(_ token: String, for tokenType: TokenType) async -> Bool
    func load(_ tokenType: TokenType) async -> String?
    func delete(_ tokenType: TokenType) async -> Bool
}
