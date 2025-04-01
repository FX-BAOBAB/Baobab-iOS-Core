//
//  TradeArticleTableViewModelTest.swift
//  BaobabTests
//
//  Created by 이정훈 on 3/10/25.
//

import Alamofire
import Factory
import RxSwift
import XCTest
@testable import Baobab

final class TradeArticleTableViewModelTest: XCTestCase {
    private var viewModel: TradeArticleTableViewModel!
    private var disposeBag: DisposeBag!

    @MainActor
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Container.shared.session.register {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockTradeArticleListURLProtocol.self]
            let session = Session(configuration: configuration)
            return session
        }
        viewModel = TradeArticleTableViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        disposeBag = nil
    }

    @MainActor
    func test_viewModel에서_게시글_요청하면_게시글_리스트_반환() throws {
        let expectation = XCTestExpectation(description: "fetch article list")
        viewModel.articles
            .skip(1)
            .subscribe(onNext: {
                XCTAssertEqual($0.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchArticles()
        wait(for: [expectation], timeout: 1)
    }
}
