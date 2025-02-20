//
//  RemoteDataSource.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Alamofire
import Foundation

protocol RemoteDatasourceProtocol {
    func get<T: Decodable>(to endpoint: String,
                           decoding type: T.Type) async throws -> T
    
    func post<T: Decodable>(to endpoint: String,
                            params: Parameters,
                            decoding type: T.Type) async throws -> T
}

final class RemoteDataSource: RemoteDatasourceProtocol {
    static let shared = RemoteDataSource()
    
    private init() {}
    
    func get<T: Decodable>(to endpoint: String, decoding type: T.Type) async throws -> T {
        return try await AF.request(endpoint)
                            .serializingDecodable(type)
                            .value
    }
    
    func post<T: Decodable>(to endpoint: String, params: Parameters, decoding type: T.Type) async throws -> T {
        return try await AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default)
                            .serializingDecodable(type)
                            .value
    }
    
    
}
