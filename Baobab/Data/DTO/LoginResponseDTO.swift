//
//  LoginResponseDTO.swift
//  Baobab
//
//  Created by 이정훈 on 2/22/25.
//

import Foundation

// MARK: - LoginResponseDTO
struct LoginResponseDTO: Decodable {
    let result: RequestResult
    let body: LoginResponseBody?
}

// MARK: - Body
struct LoginResponseBody: Decodable {
    let accessToken, accessTokenExpiredAt, refreshToken, refreshTokenExpiredAt: String
}

