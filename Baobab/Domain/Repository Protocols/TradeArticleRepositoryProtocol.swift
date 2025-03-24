//
//  TradeArticleRepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 3/4/25.
//

import Foundation

protocol TradeArticleRepositoryProtocol {
    func fetchArticles(page: Int, size: Int) async -> Result<[TradeArticle], Error>
}

extension TradeArticleRepositoryProtocol {
    func fetchArticles(page: Int, size: Int = 20) async -> Result<[TradeArticle], Error> {
        return await self.fetchArticles(page: page, size: size)
    }
}
