//
//  TradeArticleTableViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 3/7/25.
//

import Factory
import os
import RxCocoa

@MainActor
final class TradeArticleTableViewModel {
    let articles: BehaviorRelay<[TradeArticle]> = .init(value: [])
    @Injected(\.tradeArticleRepository) private var repository: TradeArticleRepositoryProtocol
    private let logger = Logger()
    var task: Task<Void, Never>?
    
    func fetchArticles() {
        task = Task {
            let result = await repository.fetchArticles()
            
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let articles):
                self.articles.accept(articles)
            case .failure(let error):
                self.logger.error("TradeArticleTableViewModel.fetchArticles() Error : \(error.localizedDescription)")
            }
        }
    }
}
