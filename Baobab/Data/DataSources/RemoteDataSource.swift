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
    /// Sends a network request to the specified endpoint and decodes the response into the given type.
    ///
    /// This method performs an asynchronous HTTP request using the specified HTTP method and parameters,
    /// then decodes the response into the provided `Decodable` type.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint path (relative to the base URL) to send the request to.
    ///   - method: The HTTP method to use for the request (e.g., `.get`, `.post`).
    ///   - parameters: The request parameters to be included (query or body, depending on the method).
    ///   - type: The type to decode the response into. Must conform to `Decodable`.
    ///   - interceptorAvailable: A flag indicating whether a request interceptor should be applied (e.g., for token refresh).
    ///
    /// - Returns: A decoded object of the specified type `T`.
    ///
    /// - Throws: An error if the request fails, the response is invalid, or decoding fails.
    ///           This can include `AFError`, `URLError`, or decoding-related errors.
    func send<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        decoding type: T.Type,
        interceptorAvailable: Bool
    ) async throws -> T
    
    /// Sends a network request to the specified endpoint and returns a publisher that emits a decoded response.
    ///
    /// This method performs an HTTP request using the given method and parameters, then publishes the decoded
    /// result as a value of the specified `Decodable` type. If the request or decoding fails, it publishes an error.
    ///
    /// - Parameters:
    ///   - endpoint: The relative endpoint path to send the request to (e.g., `"/user/info"`).
    ///   - method: The HTTP method to use for the request (e.g., `.get`, `.post`).
    ///   - parameters: The parameters to include in the request, either as query items or in the body.
    ///   - type: The type to decode the response into. Must conform to `Decodable`.
    ///   - interceptorAvailable: A flag indicating whether a request interceptor (e.g., for token refresh) should be applied.
    ///
    /// - Returns: An `AnyPublisher` that emits a decoded value of type `T` on success, or an error on failure.
    ///
    /// - Note: The returned publisher operates on the background queue by default; you should receive values on the main queue if needed.
    /// - Throws: This method does not throw directly, but the publisher may emit network or decoding errors at runtime.
    func send<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        decoding type: T.Type,
        interceptorAvailable: Bool
    ) -> AnyPublisher<T, any Error>
    
    func post<T: Decodable>(
        to endpoint: String,
        params: Parameters,
        token: String,
        decoding type: T.Type) async throws -> T
    
    func post<T: Decodable>(
        to endpoint: String,
        params: Parameters,
        decoding type: T.Type,
        interceptorAvailable: Bool) async throws -> T
    
    func upload<T: Decodable>(
        to endpoint: String,
        params: Parameters,
        decoding type: T.Type) async throws -> T
    
    func connectSSE<T: Decodable>(from url: String,
                                  decoding type: T.Type) -> AnyPublisher<T, any Error>
}

extension RemoteDataSourceProtocol {
    func post<T: Decodable>(
        to endpoint: String,
        params: Parameters,
        decoding type: T.Type,
        interceptorAvailable: Bool = true
    ) async throws -> T {
        return try await post(
            to: endpoint,
            params: params,
            decoding: type,
            interceptorAvailable: interceptorAvailable
        )
    }
    
    func send<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type,
        interceptorAvailable: Bool = true
    ) async throws -> T {
        try await self.send(endpoint, method: method, parameters: parameters, decoding: type, interceptorAvailable: interceptorAvailable)
    }
    
    func send<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type,
        interceptorAvailable: Bool = true
    ) -> AnyPublisher<T, any Error> {
        self.send(endpoint, method: method, parameters: parameters, decoding: type, interceptorAvailable: interceptorAvailable)
    }
}

final class RemoteDataSource: RemoteDataSourceProtocol {
    @Injected(\.session) private var session: Session
    
    func send<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type,
        interceptorAvailable: Bool = true
    ) async throws -> T {
        return try await session.request(
            endpoint,
            method: method,
            parameters: parameters,
            interceptor: interceptorAvailable ? TokenInterceptor.shared : nil
        )
        .serializingDecodable(type)
        .value
    }
    
    func send<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type,
        interceptorAvailable: Bool = true
    ) -> AnyPublisher<T, any Error> {
        return session.request(
            endpoint,
            method: method,
            parameters: parameters,
            interceptor: interceptorAvailable ? TokenInterceptor.shared : nil
        )
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
    
    func post<T: Decodable>(
        to endpoint: String,
        params: Parameters,
        decoding type: T.Type,
        interceptorAvailable: Bool = true
    ) async throws -> T {
        return try await session.request(
            endpoint,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            interceptor: interceptorAvailable ? TokenInterceptor.shared : nil
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
