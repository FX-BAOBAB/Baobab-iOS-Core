//
//  FileDownloadDataSource.swift
//  Baobab
//
//  Created by 이정훈 on 3/23/25.
//

import Alamofire
import Combine
import Foundation

protocol FileDownloadDataSourceProtocol {
    func downloadFile(from url: URL) -> AnyPublisher<Data, any Error>
}

final class FileDownloadDataSource: FileDownloadDataSourceProtocol {
    static let shared: FileDownloadDataSource = .init()
    
    private init() {}
    
    func downloadFile(from url: URL) -> AnyPublisher<Data, any Error> {
        return Future { promise in
            AF.request(url, method: .get)
                .responseData { response in
                    switch response.result {
                    case .success(let imageData):
                        promise(.success(imageData))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
