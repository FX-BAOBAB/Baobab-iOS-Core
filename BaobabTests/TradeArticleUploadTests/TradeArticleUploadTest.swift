//
//  TradeArticleUploadTest.swift
//  BaobabTests
//
//  Created by 이정훈 on 3/28/25.
//

import Alamofire
import Factory
import XCTest
@testable import Baobab

final class TradeArticleUploadTest: XCTestCase {
    private var remoteDataSource: RemoteDataSourceProtocol!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Container.shared.session.register {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockTradeArticleUploadURLProtocol.self]
            let session = Session(configuration: configuration)
            return session
        }
        
        remoteDataSource = Container.shared.remoteDataSource()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        remoteDataSource = nil
    }

    func test_중고거래_게시글_업로드_성공() {
        let expectation = XCTestExpectation(description: "upload trade article")
        Task {
            do {
                guard let endpoint = Bundle.main.tradeArticleEndPoint else {
                    XCTFail("Not Found EndPoint")
                    return
                }
                
                let dto = try await remoteDataSource.upload(to: endpoint + "/save", params: createParams(), decoding: PostResponseDTO.self)
                XCTAssertEqual(dto.result.resultCode, 200)
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    private func createParams() -> Parameters {
        var params: [String: Any] = [:]
        params["title"] = "테스트 제목"
        params["content"] = "테스트 내용"
        params["category"] = "DIGITAL_DEVICES"
        params["price"] = "10000"
        params["imageList"] = [(Data(), "image.jpeg", MimeType.jpeg.rawValue)]
        
        return params
    }

}
