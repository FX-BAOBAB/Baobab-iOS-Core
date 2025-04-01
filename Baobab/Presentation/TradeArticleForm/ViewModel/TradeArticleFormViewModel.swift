//
//  TradeArticleFormViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 3/24/25.
//

import Combine
import Factory
import Foundation

@MainActor
final class TradeArticleFormViewModel: ObservableObject {
    enum AlertType {
        case none, success, failure
    }
    
    @Published var selectedImageDataList: [Data] = []
    @Published var title: String = ""
    @Published var itemCategory: ItemCategory? = nil
    @Published var price: String = ""
    @Published var content: String = ""
    @Published var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    @Injected(\.tradeArticleRepository) private var repository: TradeArticleRepositoryProtocol
    var task: Task<Void, Never>?
    var alertMessage: String = ""
    var alertType: AlertType = .none
    
    func uploadArticle() {
        guard checkValidation() else {
            alertMessage = "올바른 값을 입력해주세요."
            isShowingAlert = true
            return
        }
        
        isLoading = true
        task = Task {
            let params = createParams()
            let result = await repository.upload(params)
            
            isLoading = false
            switch result {
            case .success(let message):
                alertMessage = message
                alertType = .success
            case .failure(let error):
                if let error = error as? NetworkError, case .serverError(_, let message) = error {
                    alertMessage = message
                } else {
                    alertMessage = error.localizedDescription
                }
                alertType = .failure
            }
            isShowingAlert = true
        }
    }
    
    private func checkValidation() -> Bool {
        if selectedImageDataList.count < 1 ||
            title.isEmpty ||
            itemCategory == nil ||
            price.isEmpty ||
            content.isEmpty
        {
            return false
        }
        
        return true
    }
    
    private func createParams() -> [String: Any] {
        var params: [String: Any] = [:]
        params["title"] = title
        params["content"] = content
        params["category"] = itemCategory?.rawValue ?? ""
        params["price"] = String(price)
        params["imageList"] = selectedImageDataList.map {
            ($0, "\(Date().timeIntervalSince1970)\(MimeType.jpeg.toFileExtension())", MimeType.jpeg)
        }
        
        return params
    }
}
