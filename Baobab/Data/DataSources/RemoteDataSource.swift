//
//  RemoteDataSource.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Alamofire
import Factory
import Foundation

protocol RemoteDataSourceProtocol: AnyObject {
    func get<T: Decodable>(to endpoint: String,
                           decoding type: T.Type) async throws -> T
    
    func post<T: Decodable>(to endpoint: String,
                            params: Parameters,
                            token: String,
                            decoding type: T.Type) async throws -> T
    
    func post<T: Decodable>(to endpoint: String,
                            params: Parameters,
                            decoding type: T.Type) async throws -> T
}

final class RemoteDataSource: RemoteDataSourceProtocol {
    weak var tokenInterceptor: TokenInterceptor?
    
    func get<T: Decodable>(to endpoint: String, decoding type: T.Type) async throws -> T {
        guard let interceptor = tokenInterceptor else {
            throw NetworkError.interceptorNotFound
        }
        
        return try await AF.request(endpoint, interceptor: interceptor)
                            .serializingDecodable(type)
                            .value
    }
    
    /// refresh token으로 access token을 갱신할 때 interceptor 대신 header에 직접 토큰을 주입하는 메서드
    func post<T: Decodable>(to endpoint: String,
                            params: Parameters,
                            token: String,
                            decoding type: T.Type) async throws -> T {
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        return try await AF.request(endpoint,
                                    method: .post,
                                    parameters: params,
                                    encoding: JSONEncoding.default,
                                    headers: headers)
                            .serializingDecodable(type)
                            .value
    }
    
    func post<T: Decodable>(to endpoint: String, params: Parameters, decoding type: T.Type) async throws -> T {
        return try await AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default)
                            .serializingDecodable(type)
                            .value
    }
}
