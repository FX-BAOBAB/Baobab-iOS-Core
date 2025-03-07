//
//  UserRepository.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Factory
import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    @Injected(\.remoteDataSource) private var remoteDataSource: RemoteDataSourceProtocol
    
    func signup(params: [String : Any]) async -> Result<Void, Error> {
        guard let endpoint = Bundle.main.signupEndPoint else {
            return .failure(NetworkError.invalidEndpoint)
        }

        do {
            let dto = try await remoteDataSource.post(to: endpoint, params: params, decoding: SignupResponseDTO.self)
            guard dto.result.resultCode == 200 else {
                return .failure(
                    NetworkError.serverError(
                        code: dto.result.resultCode,
                        message: dto.result.resultMessage
                    )
                )
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func login(params: [String: Any]) async throws -> (accessToken: String, refreshToken: String) {
        guard let endpoint = Bundle.main.loginEndPoint else {
            throw NetworkError.invalidEndpoint
        }
        
        let dto = try await remoteDataSource.post(to: endpoint, params: params, decoding: LoginResponseDTO.self)
        guard let body = dto.body, dto.result.resultCode == 200 else {
            throw NetworkError.serverError(code: dto.result.resultCode, message: dto.result.resultMessage)
        }
        
        return (body.accessToken, body.refreshToken)
    }
}
