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
    private var dataSource: RemoteDataSourceProtocol!
    private var interceptor: TokenInterceptor!
    private var task: Task<Void, Never>?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockTradeArticleListURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            let dataSource = RemoteDataSource(session: session)
            self.interceptor = TokenInterceptor(remoteDataSource: dataSource)
            dataSource.tokenInterceptor = self.interceptor
            return dataSource
        }
        dataSource = Container.shared.remoteDataSource()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        interceptor = nil
        task = nil
    }

    func test_중고거래_게시글_목록_조회_성공() throws {
        let expectation = XCTestExpectation(description: "fetch TradeArticleResponseDTO")
        task = Task {
            do {
                guard var endPoint = Bundle.main.tradeArticleEndPoint else {
                    throw NetworkError.invalidEndpoint
                }
                endPoint += "?page=0&size=20&sort=registeredAt,desc"
                let dto = try await dataSource.get(to: endPoint, decoding: TradeArticlesResponseDTO.self)
                XCTAssertEqual(dto.body.count, 3)
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
