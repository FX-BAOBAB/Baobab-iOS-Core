//
//  SignupFormViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 2/5/25.
//

import Combine
import Foundation

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
    
    var cancellables: Set<AnyCancellable> = []
    var alertMessage: String = ""
    
    func signup() {
        guard validateRequiredFields() else {
            isShowingAlert = true
            return
        }
        
        do {
            let params = try createParameters()
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
        
        var params = [String: Any]()
        params["email"] = email
        params["password"] = password
        params["nickName"] = nickName
        params["name"] = name
        params["carrierType"] = try carrierType.paramValue
        params["phoneNumber"] = phoneNumber
        params["genderType"] = genderType
        params["isForeigner"] = nationalityType == .citizen ? false : true
        params["birth"] = birthDate
        params["address"] = address
        params["detailAddress"] = detailAddress
        params["post"] = postCode
        params["basicAddress"] = true
        
        return params
    }
}
