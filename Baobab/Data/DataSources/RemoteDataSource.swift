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
    
    func upload<T: Decodable>(to endpoint: String,
                              params: Parameters,
                              decoding type: T.Type) async throws -> T
}

final class RemoteDataSource: RemoteDataSourceProtocol {
    @Injected(\.session) private var session: Session
    
    func get<T: Decodable>(to endpoint: String, decoding type: T.Type) async throws -> T {
        return try await session.request(endpoint, interceptor: TokenInterceptor.shared)
                            .serializingDecodable(type)
                            .value
    }
    
    /// refresh token으로 access token을 갱신할 때 interceptor 대신 header에 직접 토큰을 주입하는 메서드
    func post<T: Decodable>(to endpoint: String,
                            params: Parameters,
                            token: String,
                            decoding type: T.Type) async throws -> T {
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        return try await session.request(endpoint,
                                    method: .post,
                                    parameters: params,
                                    encoding: JSONEncoding.default,
                                    headers: headers)
                            .serializingDecodable(type)
                            .value
    }
    
    func post<T: Decodable>(to endpoint: String, params: Parameters, decoding type: T.Type) async throws -> T {
        return try await session.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default)
                            .serializingDecodable(type)
                            .value
    }
    
    func upload<T: Decodable>(to endpoint: String, params: Parameters, decoding type: T.Type) async throws -> T {
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        
        return try await session.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let data = value as? [(Data, String, MimeType)] {
                        data.forEach { (file: Data, fileName: String, mimeType: MimeType) in
                            multipartFormData.append(file, withName: "\(key)[]", fileName: fileName, mimeType: mimeType.rawValue)
                        }
                    } else if let data = value as? String, let data = "\(data)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: endpoint,
            method: .post,
            headers: headers,
            interceptor: TokenInterceptor.shared
        )
        .serializingDecodable(type)
        .value
    }
}
