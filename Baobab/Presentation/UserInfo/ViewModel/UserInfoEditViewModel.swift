//
//  UserInfoEditViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 6/3/25.
//

import Foundation

@MainActor
final class UserInfoEditViewModel: ObservableObject {
    @Published var nickName: String
    @Published var carrierType: CarrierType
    @Published var phoneNumber: String
    @Published var address: String
    @Published var detailAddress: String
    @Published var postCode: String
    @Published var proFileImage: ProfileImage
    
    init(userInfo: UserInfo) {
        self.nickName = userInfo.nickName
        self.carrierType = userInfo.phoneInfo.carrierType ?? .none
        self.phoneNumber = userInfo.phoneInfo.number
        self.address = userInfo.address.address
        self.detailAddress = userInfo.address.detailAddress
        self.postCode = userInfo.address.postCode
        self.proFileImage = userInfo.profileImage
    }
}
