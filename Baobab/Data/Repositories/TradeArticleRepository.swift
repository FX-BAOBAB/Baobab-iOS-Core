//
//  TradeArticleRepository.swift
//  Baobab
//
//  Created by 이정훈 on 3/4/25.
//

import Factory
import Foundation

final class TradeArticleRepository: TradeArticleRepositoryProtocol {
    @Injected(\.remoteDataSource) private var remoteDataSource: RemoteDataSourceProtocol
    
    func fetchArticles() async -> Result<[TradeArticle], any Error> {
        guard var endPoint = Bundle.main.tradeArticleEndPoint else {
            return .failure(NetworkError.invalidEndpoint)
        }
        
        do {
            endPoint += "?page=0&size=20&sort=registeredAt,desc"
            let dto = try await remoteDataSource.get(to: endPoint, decoding: TradeArticlesResponseDTO.self)
            return .success(createArticles(from: dto))
        } catch {
            return .failure(error)
        }
    }
    
    private func createArticles(from dto: TradeArticlesResponseDTO) -> [TradeArticle] {
        return dto.body.map {
            TradeArticle(
                id: $0.id,
                title: $0.title,
                content: $0.content,
                category: ItemCategory(rawValue: $0.category),
                price: $0.price,
                registeredAt: $0.registeredAt.toDate?.korFormattedString,
                status: ItemStatus(rawValue: $0.status),
                simpleUserInfo: createSimpleUserInfo(nickName: $0.nickname, profileURL: $0.profileImageURL),
                imageMetadata: $0.imageList.map { data in
                    ImageMetadata(id: data.imageID, imageURL: URL(string: data.imageURL))
                }
            )
        }
    }
    
    private func createSimpleUserInfo(nickName: String, profileURL: String?) -> SimpleUserInfo {
        return SimpleUserInfo(
            nickName: nickName,
            profileURL: profileURL.flatMap { URL(string: $0) }
        )
    }
}

fileprivate extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
}

fileprivate extension Date {
    var korFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return dateFormatter.string(from: self)
    }
}
