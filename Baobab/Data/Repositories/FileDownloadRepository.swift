//
//  FileDownloadRepository.swift
//  Baobab
//
//  Created by 이정훈 on 3/23/25.
//

import Combine
import Foundation

final class FileDownloadRepository: FileDownloadRepositoryProtocol {
    func download(from url: URL) -> AnyPublisher<Data, any Error> {
        return FileDownloadDataSource.shared.downloadFile(from: url)
    }
}
