//
//  TradeArticleTests.swift
//  BaobabTests
//
//  Created by 이정훈 on 3/7/25.
//

import Alamofire
import Factory
import XCTest
@testable import Baobab

final class TradeArticleTests: XCTestCase {
    private var remoteDataSource: RemoteDataSourceProtocol!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Container.shared.session.register {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockTradeArticleListURLProtocol.self]
            let session = Session(configuration: configuration)
            return session
        }
        
        remoteDataSource = Container.shared.remoteDataSource()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        remoteDataSource = nil
    }

    func test_중고거래_게시글_목록_조회_성공() {
        let expectation = XCTestExpectation(description: "fetch TradeArticleResponseDTO")
        Task {
            do {
                guard var endPoint = Bundle.main.tradeArticleEndPoint else {
                    throw NetworkError.invalidEndpoint
                }
                endPoint += "?page=0&size=20&sort=registeredAt,desc"
                let dto = try await remoteDataSource.get(to: endPoint, decoding: TradeArticlesResponseDTO.self)
                XCTAssertEqual(dto.body.count, 3)
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
