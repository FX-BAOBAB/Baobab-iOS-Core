//
//  Factory+ViewModel.swift
//  Baobab
//
//  Created by 이정훈 on 1/30/25.
//

import Factory

extension Container {
    var loginViewModel: Factory<LoginFormModel> {
        Factory(self) {
            LoginFormModel()
        }
    }
}
