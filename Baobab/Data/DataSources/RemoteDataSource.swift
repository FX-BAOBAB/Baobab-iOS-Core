//
//  RemoteDataSource.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Alamofire
import Combine
import Factory
import Foundation

protocol RemoteDataSourceProtocol: AnyObject {
    func get<T: Decodable>(to endpoint: String,
                           decoding type: T.Type) async throws -> T
    
    func get<T: Decodable>(to endpoint: String,
                           decoding type: T.Type) -> AnyPublisher<T, any Error>
    
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
    
    func connectSSE<T: Decodable>(from url: String,
                                  decoding type: T.Type) -> AnyPublisher<T, any Error>
}

final class RemoteDataSource: RemoteDataSourceProtocol {
    @Injected(\.session) private var session: Session
    
    func get<T: Decodable>(to endpoint: String, decoding type: T.Type) async throws -> T {
        return try await session.request(endpoint, interceptor: TokenInterceptor.shared)
                            .serializingDecodable(type)
                            .value
    }
    
    func get<T>(to endpoint: String, decoding type: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        return session.request(endpoint, interceptor: TokenInterceptor.shared)
            .publishDecodable(type: T.self)
            .value()
            .mapError {
                $0 as Error
            }
            .eraseToAnyPublisher()
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
        return try await session.request(
            endpoint,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            interceptor: TokenInterceptor.shared
        )
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
                            multipartFormData.append(file, withName: "\(key)", fileName: fileName, mimeType: mimeType.rawValue)
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
    
    func connectSSE<T: Decodable>(
        from url: String,
        decoding type: T.Type
    ) -> AnyPublisher<T, any Error> {
        session.streamRequest(url, interceptor: TokenInterceptor.shared)
            .publishStream(using: .string)
            .dropFirst()    //첫 번째 연결 확인 메시지는 버림
            .tryMap { stream -> String in
                if case .stream(let result) = stream.event {
                    return try result.get()
                }
                
                throw URLError(.badServerResponse)
            }
            .filter {
                $0 != "event:CHAT\ndata:"
            }
            .compactMap { result in
                return result.split(separator: "data:")
                    .last?
                    .trimmingCharacters(in: .whitespaces)
            }
            .tryMap { jsonString in
                guard let jsonData = jsonString.data(using: .utf8) else {
                    throw URLError(.badServerResponse)
                }
                
                return try JSONDecoder().decode(T.self, from: jsonData)
            }
            .eraseToAnyPublisher()
    }
}
