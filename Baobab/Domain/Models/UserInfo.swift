//
//  UserInfo.swift
//  Baobab
//
//  Created by 이정훈 on 6/2/25.
//

import Foundation

struct UserInfo: Identifiable {
    let id: String
    let email: String
    let nickName: String
    let name: String
    let phoneInfo: PhoneInfo
    let address: UserAddress
    let profileImage: ProfileImage
}

struct PhoneInfo {
    let carrierType: CarrierType?
    let number: String
}

struct UserAddress {
    let address: String
    let detailAddress: String
    let postCode: String
}

struct ProfileImage {
    let imageURL: String
    let imageId: String
}
