//
//  FetchChatRoomsTest.swift
//  BaobabTests
//
//  Created by 이정훈 on 4/4/25.
//

import Alamofire
import Factory
import XCTest
@testable import Baobab

final class FetchChatRoomsTest: XCTestCase {
    private var remoteDataSource: RemoteDataSourceProtocol!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Container.shared.session.register {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockChatRoomsURLProtocol.self]
            let session = Session(configuration: configuration)
            
            return session
        }
        
        remoteDataSource = Container.shared.remoteDataSource()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        remoteDataSource = nil
    }
    
    func test_사용자_채팅목록_조회_성공() {
        let expectation = XCTestExpectation(description: "fetch chat rooms")
        Task {
            guard let endpoint = Bundle.main.chatEndPoint else {
                XCTFail(NetworkError.invalidEndpoint.localizedDescription)
                return
            }
            
            do {
                let dto = try await remoteDataSource.get(to: endpoint + "/rooms", decoding: ChatRoomsResponseDTO.self)
                XCTAssertEqual(dto.result.resultCode, 200)
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }

}
