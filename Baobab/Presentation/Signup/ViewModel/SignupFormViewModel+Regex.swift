//
//  SignupFormViewModel+Regex.swift
//  Baobab
//
//  Created by 이정훈 on 2/13/25.
//

import Foundation

extension SignupFormViewModel: RegexValidatable {
    func bindWithRegex() {
        $email
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { [weak self] newValue -> InputState in
                if self?.validate(email: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[0], on: self)
            .store(in: &cancellables)
        
        $password
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { [weak self] newValue -> InputState in
                if self?.validate(password: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[1], on: self)
            .store(in: &cancellables)
        
        $confirmPassword
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { [weak self] newValue -> InputState in
                if newValue == self?.password {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[2], on: self)
            .store(in: &cancellables)
        
        $nickName
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { [weak self] newValue -> InputState in
                if self?.validate(nickName: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[3], on: self)
            .store(in: &cancellables)
        
        $name
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { [weak self] newValue -> InputState in
                if self?.validate(name: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[4], on: self)
            .store(in: &cancellables)
        
        $birthDate
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { [weak self] newValue -> InputState in
                if self?.validate(birthDate: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[5], on: self)
            .store(in: &cancellables)
        
        $genderType
            .dropFirst()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { newValue -> InputState in
                if newValue != nil {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[6], on: self)
            .store(in: &cancellables)
        
        $nationalityType
            .dropFirst()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { newValue -> InputState in
                if newValue != nil {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[7], on: self)
            .store(in: &cancellables)
        
        $carrierType
            .dropFirst()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { newValue -> InputState in
                if newValue == .none {
                    return .invalid
                }
                return .valid
            }
            .assign(to: \.inputStates[8], on: self)
            .store(in: &cancellables)
        
        $phoneNumber
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { [weak self] newValue -> InputState in
                if self?.validate(phoneNumber: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[9], on: self)
            .store(in: &cancellables)
        
        $postCode
            .combineLatest($address, $detailAddress)
            .dropFirst(4)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { (postCode, address, detailAddress) -> InputState in
                if !postCode.isEmpty && !address.isEmpty && !detailAddress.isEmpty {
                    return .valid
                }
                return .invalid
            }
            .assign(to: \.inputStates[10], on: self)
            .store(in: &cancellables)
    }
}
