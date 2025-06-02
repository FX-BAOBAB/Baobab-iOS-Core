//
//  UserRepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 6/2/25.
//

import Foundation

/// 사용자 정보 데이터를 가져오는 Repository
protocol UserRepositoryProtocol {
    /// Remote 서버에서 사용자 정보 데이터를 가져오는 함수
    ///
    /// - Returns: 유저 정보를 가지고 있는 `UserInfo`  인스턴스
    func fetchUserInfo() async -> Result<UserInfo, any Error>
}
