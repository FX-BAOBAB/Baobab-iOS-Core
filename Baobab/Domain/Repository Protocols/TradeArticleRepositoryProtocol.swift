//
//  TradeArticleRepositoryProtocol.swift
//  Baobab
//
//  Created by 이정훈 on 3/4/25.
//

import Foundation

protocol TradeArticleRepositoryProtocol {
    func fetchArticles() async -> Result<[TradeArticle], Error>
}
