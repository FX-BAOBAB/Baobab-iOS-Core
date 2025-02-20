//
//  RequestResult.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Foundation

// MARK: - Result
struct RequestResult: Decodable {
    let resultCode: Int
    let resultMessage, resultDescription: String
}
