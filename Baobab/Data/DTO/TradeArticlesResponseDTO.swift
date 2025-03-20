//
//  TradeArticlesResponseDTO.swift
//  Baobab
//
//  Created by 이정훈 on 3/4/25.
//

import Foundation

// MARK: - TradeArticlesResponseDTO
struct TradeArticlesResponseDTO: Decodable {
    let result: RequestResult
    let body: [TradeArticlesResponseBody]
}

// MARK: - Body
struct TradeArticlesResponseBody: Codable {
    let id, title, content, category: String
    let price: Int
    let registeredAt, status: String
    let imageList: [ImageList]
    let nickname: String
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, title, content, category, price, registeredAt, status, imageList, nickname
        case profileImageURL = "profileImageUrl"
    }
}

// MARK: - ImageList
struct ImageList: Codable {
    let imageID: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageID = "imageId"
        case imageURL = "imageUrl"
    }
}
