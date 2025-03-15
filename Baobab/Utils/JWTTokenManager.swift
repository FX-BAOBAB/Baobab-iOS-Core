//
//  JWTTokenManager.swift
//  Baobab
//
//  Created by 이정훈 on 2/22/25.
//

import Foundation
import Security

struct JWTTokenManager {
    static let shared: JWTTokenManager = .init()
    var accessToken: String? {
        load(.accessToken)
    }
    var refreshToken: String? {
        load(.refreshToken)
    }
    
    private init() {}
    
    @discardableResult
    func save(_ token: String, for tokenType: TokenType) -> Bool {
        let saveQuery: NSDictionary = [
            kSecClass: kSecClassKey,    //키체임 암호화 클래스: 암호화 키
            kSecAttrType: tokenType.rawValue,
            kSecValueData: token.data(using: .utf8) as Any    //저장할 데이터
        ]
        let status: OSStatus = SecItemAdd(saveQuery, nil)
        
        if status == errSecSuccess {
            return true
        }
        return false
    }
    
    private func load(_ tokenType: TokenType) -> String? {
        let loadQuery: NSDictionary = [
            kSecClass: kSecClassKey,
            kSecAttrType: tokenType.rawValue,
            kSecReturnData: true    //item 데이터 반환 여부
        ]
        var loadedData: CFTypeRef?
        let loadStatus: OSStatus = SecItemCopyMatching(loadQuery, &loadedData)
        
        if loadStatus == errSecSuccess {
            guard let loadedData = loadedData,
                  let token = loadedData as? Data else {
                return nil
            }
            
            return String(data: token, encoding: .utf8)
        }
        return nil
    }
    
    @discardableResult
    func delete(_ tokenType: TokenType) -> Bool {
        let deleteQuery: NSDictionary = [
            kSecClass: kSecClassKey,
            kSecAttrType: tokenType.rawValue,
        ]
        let deleteStatus: OSStatus = SecItemDelete(deleteQuery)
        
        if deleteStatus == errSecSuccess {
            return true
        }
        return false
    }
    
    func fetchNewAccessToken(from refreshToken: String) async throws -> String {
        guard let endpoint = Bundle.main.reissueEndPoint else {
            throw NetworkError.invalidEndpoint
        }
        
        let params: [String: Any?] = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": nil
        ]
        
        let dto = try await RemoteDataSource.shared.post(to: endpoint, params: params, token: refreshToken, decoding: TokenReissueResponseDTO.self)
        return dto.body.token
    }
}
