//
//  MockTradeArticleListURLProtocol.swift
//  BaobabTests
//
//  Created by 이정훈 on 3/7/25.
//

import Foundation

final class MockTradeArticleListURLProtocol: MockURLProtocol {
    override func createMockData() -> Data? {
        let fileName = "TradeArticleList"
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: fileURL)
    }
}
