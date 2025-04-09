//
//  LoginViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 1/30/25.
//

import Combine
import Factory
import Foundation

@MainActor
final class LoginFormViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAutoLogin: Bool = false
    @Published var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    
    @Injected(\.loginUseCase) private var loginUseCase: LoginUseCaseProtocol
    private(set) var loginTask: Task<Void, Never>?
    private(set) var alertMessage: String = ""
    
    func login() {
        guard validateInput() else {
            alertMessage = "올바른 아이디와 비밀번호를 입력해주세요."
            isShowingAlert = true
            return
        }
        
        Task {
            isLoading = true
            let result = await loginUseCase.execute(params: createParameters())
            
            guard !Task.isCancelled else {
                return
            }
            
            isLoading = false
            switch result {
            case .success:
//                isLoginComplete = true
                NotificationCenter.default.post(name: .loginSuccess, object: nil)
            case .failure(let error):
                if let error = error as? NetworkError, case .serverError(let errorCode, let message) = error {
                    alertMessage = "\(errorCode): \(message)"
                } else {
                    alertMessage = error.localizedDescription
                }
                isShowingAlert = true
            }
        }
    }
    
    private func validateInput() -> Bool {
        return [email, password].allSatisfy { !$0.isEmpty }
    }
    
    private func createParameters() -> [String: Any] {
        let params: [String: [String: Any]] = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "email": email,
                "password": password
            ]
        ]
        
        return params
    }
}
