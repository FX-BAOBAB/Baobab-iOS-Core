//
//  TokenInterceptor.swift
//  Baobab
//
//  Created by 이정훈 on 3/4/25.
//

import Alamofire
import Factory
import Foundation

actor TokenInterceptor: RequestInterceptor {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    private weak var remoteDataSource: RemoteDataSourceProtocol?
    
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    nonisolated func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        Task {
            var urlRequest = urlRequest
            guard let accessToken = await tokenRepository.load(.accessToken) else {
                completion(.failure(NetworkError.noTokenValue))
                return
            }
            
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
            completion(.success(urlRequest))
        }
    }
    
    nonisolated func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        Task {
            guard let refreshToken = await tokenRepository.load(.refreshToken) else {
                completion(.doNotRetryWithError(NetworkError.noTokenValue))
                return
            }
            
            guard let endpoint = Bundle.main.reissueEndPoint else {
                completion(.doNotRetryWithError(NetworkError.invalidEndpoint))
                return
            }
            
            let params: [String: Any?] = [
                "result": [
                    "resultCode": 0,
                    "resultMessage": "string",
                    "resultDescription": "string"
                ],
                "body": nil
            ]
            
            do {
                let dto = try await remoteDataSource?.post(to: endpoint, params: params, token: refreshToken, decoding: TokenReissueResponseDTO.self)
                guard let accessToken = dto?.body.token else {
                    completion(.doNotRetryWithError(NetworkError.noTokenValue))
                    return
                }
                await tokenRepository.save(accessToken, for: .accessToken)
                
                if request.retryCount < 1 {
                    completion(.retry)
                } else {
                    //Refresh Token 만료
                    completion(.doNotRetry)
                    NotificationCenter.default.post(name: .refreshTokenExpired, object: nil)
                }
            } catch {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
