//
//  PostRequestDTO.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Foundation

// MARK: - SignupResponseDTO
struct SignupResponseDTO: Decodable {
    let result: RequestResult
    let body: SignupResponseBody?
}

// MARK: - Body
struct SignupResponseBody: Decodable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
