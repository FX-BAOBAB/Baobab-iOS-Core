//
//  TokenInterceptor.swift
//  Baobab
//
//  Created by 이정훈 on 3/4/25.
//

import Alamofire
import Factory
import Foundation

struct TokenInterceptor: RequestInterceptor {
    static let shared: TokenInterceptor = .init()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        guard let accessToken = JWTTokenManager.shared.accessToken else {
            completion(.failure(NetworkError.noTokenValue))
            return
        }
        
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        Task {
            guard let refreshToken = JWTTokenManager.shared.refreshToken else {
                completion(.doNotRetryWithError(NetworkError.noTokenValue))
                return
            }
            
            do {
                let newAccessToken = try await JWTTokenManager.shared.fetchNewAccessToken(from: refreshToken)
                JWTTokenManager.shared.save(newAccessToken, for: .accessToken)
                
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
