//
//  LoginViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 1/30/25.
//

import Combine

final class LoginFormModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAutoLogin: Bool = false
}
