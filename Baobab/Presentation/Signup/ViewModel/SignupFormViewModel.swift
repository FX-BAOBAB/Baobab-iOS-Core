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
    @Published var confirmPassword: String = ""
    @Published var name: String = ""
    @Published var nickName: String = ""
    @Published var carrierType: CarrierType = .none
    @Published var phoneNumber: String = ""
    @Published var genderType: GenderType? = nil
    @Published var isForeigner: Bool? = nil
    @Published var birthDate: String = ""
    @Published var postCode: String = ""
    @Published var address: String = ""
    @Published var detailAddress: String = ""
    @Published var isBasicAddress: Bool = false
}
