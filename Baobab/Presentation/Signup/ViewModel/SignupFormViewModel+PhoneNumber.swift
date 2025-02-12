//
//  SignupFormViewModel+PhoneNumber.swift
//  Baobab
//
//  Created by 이정훈 on 2/12/25.
//

import Foundation

extension SignupFormViewModel {
    func formatPhoneNumber() {
        if phoneNumber.count == 4 && phoneNumber.last != "-" {
            insertHyphen(to: &phoneNumber, at: 3)
        } else if phoneNumber.count == 9 && phoneNumber.last != "-" {
            insertHyphen(to: &phoneNumber, at: 8)
        }
    }
    
    private func insertHyphen(to str: inout String, at index: Int) {
        guard index < str.count else { return }
        
        var charArray = Array(str)
        charArray.insert("-", at: index)
        str = String(charArray)
    }
}
