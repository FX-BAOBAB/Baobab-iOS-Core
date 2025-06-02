//
//  UserRepository.swift
//  Baobab
//
//  Created by 이정훈 on 6/2/25.
//

import Factory
import Foundation

final class UserRepository: UserRepositoryProtocol {
    @Injected(\.remoteDataSource) private var dataSource
    
    func fetchUserInfo() async -> Result<UserInfo, any Error> {
        guard let endPoint = Bundle.main.userEndPoint else {
            return .failure(NetworkError.invalidEndpoint)
        }
        
        do {
            let dto = try await dataSource.get(to: endPoint + "/info", decoding: UserInfoDTO.self)
            let userInfo = UserInfo(
                id: dto.body.userID,
                email: dto.body.email,
                nickName: dto.body.nickName,
                name: dto.body.name,
                phoneInfo: PhoneInfo(
                    carrierType: CarrierType(rawValue: dto.body.userPhoneInfo.carrierType),
                    number: dto.body.userPhoneInfo.phoneNumber
                ),
                address: UserAddress(
                    address: dto.body.userAddress.address,
                    detailAddress: dto.body.userAddress.detailAddress,
                    postCode: dto.body.userAddress.post
                ),
                profileImage: ProfileImage(
                    imageURL: dto.body.profileImage.imageURL,
                    imageId: dto.body.profileImage.imageID)
            )
            
            return .success(userInfo)
        } catch {
            return .failure(error)
        }
    }
}
