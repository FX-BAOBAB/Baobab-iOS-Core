//
//  MockTradeArticleUploadURLProtocol.swift
//  BaobabTests
//
//  Created by 이정훈 on 3/28/25.
//

import Foundation

final class MockTradeArticleUploadURLProtocol: MockURLProtocol {
    override var mockDataFileName: String {
        return "PostSuccessResponse"
    }
}
