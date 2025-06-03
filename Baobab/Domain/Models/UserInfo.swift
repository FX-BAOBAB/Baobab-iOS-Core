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

#if DEBUG
extension UserInfo {
    static var sampleData: Self {
        UserInfo(
            id: "obab",
            email: "obab@baobab.com",
            nickName: "오밥",
            name: "김오밥",
            phoneInfo: PhoneInfo(carrierType: .kt, number: "010-XXXX-XXXX"),
            address: UserAddress(address: "경기도 성남시 분당구 삼평동", detailAddress: "판교역로 160", postCode: "13524"),
            profileImage: ProfileImage(imageURL: "imageURL", imageId: "imageId")
        )
    }
}
#endif
