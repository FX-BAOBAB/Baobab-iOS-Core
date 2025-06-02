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
    ///   - endpoint: The endpoint path (relative to the base URL) to send the request.
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
    ///   - endpoint:The endpoint path (relative to the base URL) to send the request.
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
    
    /// Sends a POST request to the specified endpoint with parameters and an authorization token,
    /// and decodes the response into the specified type.
    ///
    /// This method performs an asynchronous HTTP POST request with the given parameters and token.
    /// The response is then decoded into the specified `Decodable` type.
    ///
    /// - Parameters:
    ///   - endpoint: The relative URL path to send the POST request.
    ///   - params: The parameters to include in the request body.
    ///   - token: The bearer token used for authorization in the request header.
    ///   - type: The type to decode the response into. Must conform to `Decodable`.
    ///
    /// - Returns: A decoded object of type `T` from the response body.
    ///
    /// - Throws: An error if the request fails, the response is invalid, or decoding fails.
    ///           This may include networking errors, authorization failures, or `DecodingError`s.
    func post<T: Decodable>(
        to endpoint: String,
        params: Parameters,
        token: String,
        decoding type: T.Type) async throws -> T
    
    /// Uploads multipart form data to the specified endpoint and decodes the response into the given type.
    ///
    /// This method sends a `multipart/form-data` POST request using the provided parameters. The parameters
    /// can include both text fields (`String`) and file data (as `(Data, fileName, MimeType)` tuples).
    /// The response is then decoded into the specified `Decodable` type.
    ///
    /// - Parameters:
    ///   - endpoint: The relative URL path to send the upload request.
    ///   - params: A dictionary of form data where each value can be either a `String` or an array of file data tuples.
    ///             For file uploads, each value must be of type `[(Data, String, MimeType)]`.
    ///   - type: The expected type to decode from the server's response. Must conform to `Decodable`.
    ///
    /// - Returns: A decoded object of the specified type `T`.
    ///
    /// - Throws: An error if the upload request fails or if the response cannot be decoded.
    ///           This can include networking errors, serialization errors, or `DecodingError`s.
    ///
    /// - Note:
    ///   - Uses `multipart/form-data` as the content type.
    ///   - Automatically includes `TokenInterceptor.shared` for authenticated requests.
    ///   - Files are appended with `withName: key`, using the MIME type from `MimeType`.
    func upload<T: Decodable>(
        to endpoint: String,
        params: Parameters,
        decoding type: T.Type) async throws -> T
    
    /// Connects to a Server-Sent Events (SSE) stream and decodes incoming events into the specified type.
    ///
    /// This method establishes an SSE connection to the given URL and continuously listens for events from the server.
    /// Each event is decoded into the specified `Decodable` type and published through a Combine `AnyPublisher`.
    ///
    /// - Parameters:
    ///   - url: The URL of the SSE endpoint to connect.
    ///   - type: The type to decode each incoming SSE event into. Must conform to `Decodable`.
    ///
    /// - Returns: An `AnyPublisher` that emits decoded values of type `T` for each event received,
    ///            or an error if the connection or decoding fails.
    ///
    /// - Note:
    ///   - This method uses Server-Sent Events (SSE), which is a unidirectional stream from server to client.
    ///   - The stream remains open until cancelled, so be sure to manage the subscription's lifecycle.
    ///   - SSE is typically used for real-time updates, such as notifications, logs, or data streams.
    ///
    /// - Throws: This method itself does not throw directly, but the returned publisher may emit errors such as
    ///           connection failures or decoding errors during its lifetime.
    func connectSSE<T: Decodable>(
        from url: String,
        decoding type: T.Type) -> AnyPublisher<T, any Error>
}

extension RemoteDataSourceProtocol {
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
            encoding: JSONEncoding.default,
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
            encoding: JSONEncoding.default,
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
