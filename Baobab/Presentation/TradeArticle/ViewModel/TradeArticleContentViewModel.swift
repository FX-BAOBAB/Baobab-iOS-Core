//
//  TradeArticleContentViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 3/23/25.
//

import Factory
import Foundation
import os

@MainActor
final class TradeArticleContentViewModel: ObservableObject {
    @Published var imagesData: [Data]? = nil
    @Injected(\.fileDownloadUseCase) private var usecase: FileDownloadUseCaseProtocol
    private var logger: Logger = Logger()
    
    func fetchImages(from imagesMetadata: [ImageMetadata]) async {
        do {
            let urls = imagesMetadata.compactMap(\.imageURL)
            for try await imagesData in usecase.execute(fileURLs: urls).values {
                self.imagesData = imagesData
            }
        } catch {
            logger.error("TradeArticleContentViewModel.fetchImageData(from:) error: \(error.localizedDescription)")
        }
    }
}
