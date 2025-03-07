//
//  TokenReissueResponseDTO.swift
//  Baobab
//
//  Created by 이정훈 on 3/4/25.
//

import Foundation

// MARK: - TokenReissueResponseDTO
struct TokenReissueResponseDTO: Decodable {
    let result: RequestResult
    let body: TokenReissueResponseBody
}

// MARK: - Body
struct TokenReissueResponseBody: Decodable {
    let token, expiredAt: String
}
