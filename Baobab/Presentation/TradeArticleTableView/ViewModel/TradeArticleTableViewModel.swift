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
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    @Injected(\.tradeArticleRepository) private var repository: TradeArticleRepositoryProtocol
    private var page: Int = 0
    private let logger = Logger()
    var task: Task<Void, Never>?
    
    func fetchArticles() {
        task = Task {
            let result = await repository.fetchArticles(page: page)
            
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let articles):
                self.articles.accept(articles)
            case .failure(let error):
                self.logger.error("TradeArticleTableViewModel.fetchArticles() Error : \(error.localizedDescription)")
            }
        }
    }
    
    func fetchNextPage() {
        isLoading.accept(true)
        page += 1
        task = Task {
            let result = await repository.fetchArticles(page: page)
            
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let articles):
                self.articles.accept(articles)
            case .failure(let error):
                self.logger.error("TradeArticleTableViewModel.fetchNextPage() Error : \(error.localizedDescription)")
                page -= 1
            }
            isLoading.accept(false)
        }
    }
}
