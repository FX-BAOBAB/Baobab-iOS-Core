//
//  TokenRepository.swift
//  Baobab
//
//  Created by 이정훈 on 2/22/25.
//

import Foundation
import Security

final class TokenRepository: TokenRepositoryProtocol {
    @discardableResult
    func save(_ token: String, for tokenType: TokenType) async -> Bool {
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
    
    func load(_ tokenType: TokenType) async -> String? {
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
    func delete(_ tokenType: TokenType) async -> Bool {
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
}
