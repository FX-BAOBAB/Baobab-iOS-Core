//
//  UserRepository.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Factory
import Foundation

final class UserRepository: UserRepositoryProtocol {
    @Injected(\.remoteDataSource) private var remoteDataSource: RemoteDatasourceProtocol
    
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
}
