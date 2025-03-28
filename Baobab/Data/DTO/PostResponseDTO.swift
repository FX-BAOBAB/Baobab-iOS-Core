//
//  PostResponseDTO.swift
//  Baobab
//
//  Created by 이정훈 on 3/28/25.
//

import Foundation

// MARK: - PostResponseDTO
struct PostResponseDTO: Decodable {
    let result: RequestResult
    let body: Bool?
}
