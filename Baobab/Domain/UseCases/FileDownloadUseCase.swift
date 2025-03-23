//
//  FileDownloadUseCase.swift
//  Baobab
//
//  Created by 이정훈 on 3/23/25.
//

import Combine
import Factory
import Foundation

protocol FileDownloadUseCaseProtocol {
    func execute(fileURLs: [URL]) -> AnyPublisher<[Data], any Error>
}

final class FileDownloadUseCase: FileDownloadUseCaseProtocol {
    @Injected(\.fileDownloadRepository) private var repository: FileDownloadRepositoryProtocol
    
    func execute(fileURLs: [URL]) -> AnyPublisher<[Data], any Error> {
        var publishers: [AnyPublisher<Data, any Error>] = []
        fileURLs.forEach { URL in
            publishers.append(repository.download(from: URL))
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
}
