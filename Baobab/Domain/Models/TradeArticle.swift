//
//  TradeArticle.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import Foundation

struct TradeArticle: Identifiable {
    let id: String    //게시글 ID
    let title: String    //게시글 제목
    let content: String    //게시글 본문
    let category: ItemCategory?    //중고 물품 카테고리
    let price: Int    //중고 물품 가격
    let registeredAt: String?    //게시글 등록 날짜
    let status: ItemStatus?    //중고 물품 상태
    let simpleUserInfo: SimpleUserInfo    //게시글 작성자 정보
    let imageMetadata: [ImageMetadata]    //이미지 데이터
}

#if DEBUG
extension TradeArticle {
    static var sampleData: TradeArticle {
        .init(
            id: "1234567890",
            title: "샘플 중고 물건",
            content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            category: .digitalDevice,
            price: 10000,
            registeredAt: "2025년 03월 04일 13:35",
            status: .onSale,
            simpleUserInfo: .init(nickName: "닉네임", profileURL: URL(string: "https://baobab.run/article-service/open-api/images/53edc0be-e824-4b38-8c10-7556e6b4f557.png")),
            imageMetadata: [
                ImageMetadata.sample,
                ImageMetadata.sample,
                ImageMetadata.sample,
                ImageMetadata.sample,
                ImageMetadata.sample
            ])
    }
}
#endif
