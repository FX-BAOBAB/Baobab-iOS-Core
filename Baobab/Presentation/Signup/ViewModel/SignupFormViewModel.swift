//
//  SignupFormViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 2/5/25.
//

import Combine
import Factory
import Foundation

@MainActor
final class SignupFormViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var name: String = ""
    @Published var nickName: String = ""
    @Published var carrierType: CarrierType = .none
    @Published var phoneNumber: String = ""
    @Published var genderType: GenderType? = nil
    @Published var nationalityType: NationalityType? = nil
    @Published var birthDate: String = ""
    @Published var postCode: String = ""
    @Published var address: String = ""
    @Published var detailAddress: String = ""
    @Published var inputStates: [InputState] = Array(repeating: .initial, count: 11)
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = false
    
    @Injected(\.userRepository) private var repository: UserRepositoryProtocol
    var signupTask: Task<Void, Never>?
    var cancellables: Set<AnyCancellable> = []
    var alertMessage: String = ""
    var alertType: AlertType = .none
    
    func signup() {
        guard validateRequiredFields() else {
            isShowingAlert = true
            return
        }
        
        do {
            let params = try createParameters()
            signupTask = Task {
                isLoading = true
                let result = await repository.signup(params: params)
                
                guard !Task.isCancelled else { return }    //Task 취소 후 더 이상 진행하지 않음
                switch result {
                case .success:
                    alertMessage = "회원가입에 성공했어요!"
                    alertType = .success
                case .failure(let error):
                    if let error = error as? NetworkError, case .serverError(let errorCode, let message) = error {
                        alertMessage = "\(errorCode): \(message)"
                    } else {
                        alertMessage = error.localizedDescription
                    }
                    alertType = .failure
                }
                
                isLoading = false
                isShowingAlert.toggle()
            }
        } catch {
            if let error = error as? SignupInputError {
                alertMessage = error.rawValue
            } else {
                alertMessage = "필수 입력 사항을 정확하게 입력해 주세요."
            }
        }
    }
    
    private func validateRequiredFields() -> Bool {
        var isAllValid: Bool = true
        // 입력 상태는 거꾸로 확인하고 alert은 가장 상단 항목부터 표시
        for i in inputStates.indices.reversed() where inputStates[i] == .initial || inputStates[i] == .invalid {
            inputStates[i] = .invalid
            isAllValid = false
            alertMessage = SignupInputError.allCases[i].rawValue
        }
        
        return isAllValid
    }
    
    private func createParameters() throws -> [String: Any] {
        guard let genderType = genderType?.paramValue else {
            throw SignupInputError.invalidPhoneNumber
        }
        
        guard let nationalityType = nationalityType else {
            throw SignupInputError.invalidNationalityType
        }
        
        let params: [String: [String: Any]] = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "email": email,
                "password": password,
                "name": name,
                "nickName": nickName,
                "carrierType": try carrierType.paramValue,
                "phoneNumber": phoneNumber,
                "genderType": genderType,
                "isForeigner": nationalityType == .citizen ? false : true,
                "birth" : birthDate,
                "address": address,
                "detailAddress": detailAddress,
                "post": postCode,
                "basicAddress": true
            ]
        ]
        
        return params
    }
}
