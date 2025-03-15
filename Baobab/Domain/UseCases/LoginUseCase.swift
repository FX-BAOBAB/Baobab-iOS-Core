//
//  LoginUseCase.swift
//  Baobab
//
//  Created by 이정훈 on 2/22/25.
//

import Factory
import Foundation

protocol LoginUseCaseProtocol {
    func execute(params: [String: Any]) async -> Result<Void, Error>
}

final class LoginUseCase: LoginUseCaseProtocol {
    @Injected(\.authRepository) private var authRepository: AuthRepositoryProtocol
    
    func execute(params: [String: Any]) async -> Result<Void, Error> {
        do {
            let (accessToken, refreshToken) = try await authRepository.login(params: params)
            //기존 토큰 값 삭제
            JWTTokenManager.shared.delete(.accessToken)
            JWTTokenManager.shared.delete(.refreshToken)
            
            //새로운 토큰 저장
            JWTTokenManager.shared.save(accessToken, for: .accessToken)
            JWTTokenManager.shared.save(refreshToken, for: .refreshToken)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
