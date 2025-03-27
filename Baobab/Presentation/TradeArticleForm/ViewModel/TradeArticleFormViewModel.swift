//
//  TradeArticleFormViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 3/24/25.
//

import Combine
import Foundation

final class TradeArticleFormViewModel: ObservableObject {
    @Published var selectedImageDataList: [Data] = []
    @Published var title: String = ""
    @Published var itemCategory: ItemCategory? = nil
    @Published var price: String = ""
    @Published var content: String = ""
}
