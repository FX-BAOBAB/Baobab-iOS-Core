//
//  UserInfoDTO.swift
//  Baobab
//
//  Created by 이정훈 on 6/2/25.
//

import Foundation

// MARK: - UserInfoDTO
struct UserInfoDTO: Decodable {
    let result: RequestResult
    let body: UserInfoDTOBody
}

// MARK: - Body
struct UserInfoDTOBody: Decodable {
    let userID, email, nickName, name: String
    let userPhoneInfo: UserPhoneInfo
    let genderType: String
    let isForeigner: Bool
    let birth: String
    let userAddress: UserAddressDTO
    let profileImage: ProfileImageDTO
    let role, status, registeredAt: String
    let unRegisteredAt: String?
    let lastLoginAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case email, nickName, name, userPhoneInfo, genderType, isForeigner, birth, userAddress, profileImage, role, status, registeredAt, unRegisteredAt, lastLoginAt
    }
}

// MARK: - ProfileImageDTO
struct ProfileImageDTO: Decodable {
    let imageURL, imageID: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case imageID = "imageId"
    }
}

// MARK: - UserAddressDTO
struct UserAddressDTO: Decodable {
    let address, detailAddress: String
    let basicAddress: Bool
    let post: String
}

// MARK: - UserPhoneInfo
struct UserPhoneInfo: Decodable {
    let carrierType, phoneNumber: String
}
