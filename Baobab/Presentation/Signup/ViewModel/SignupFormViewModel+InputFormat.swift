//
//  SignupFormViewModel+PhoneNumber.swift
//  Baobab
//
//  Created by 이정훈 on 2/12/25.
//

import Foundation

extension SignupFormViewModel {
    func formatPhoneNumber() {
        guard phoneNumber.last != "-" else { return }
        if phoneNumber.count == 4 || phoneNumber.count == 9 {
            insertHyphen(to: &phoneNumber, at: phoneNumber.count - 1)
        }
    }
    
    func formatBirthDate() {
        guard birthDate.last != "-" else { return }
        if birthDate.count == 5 || birthDate.count == 8 {
            insertHyphen(to: &birthDate, at: birthDate.count - 1)
        }
    }
    
    private func insertHyphen(to str: inout String, at index: Int) {
        guard index < str.count else { return }
        
        var charArray = Array(str)
        charArray.insert("-", at: index)
        str = String(charArray)
    }
}
