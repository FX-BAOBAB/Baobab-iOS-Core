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
    let imageList: [ImageData]    //이미지 데이터
}
