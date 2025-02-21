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
            .debounce(for: 1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .map { [weak self] newValue -> InputState in
                print(Thread.current)
                if self?.validate(email: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.inputStates[0] = $0
            }
            .store(in: &cancellables)
        
        $password
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .map { [weak self] newValue -> InputState in
                if self?.validate(password: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.inputStates[1] = $0
            }
            .store(in: &cancellables)
        
        $passwordConfirmation
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .map { [weak self] newValue -> InputState in
                if newValue == self?.password {
                    return .valid
                }
                return .invalid
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.inputStates[2] = $0
            }
            .store(in: &cancellables)
        
        $nickName
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .map { [weak self] newValue -> InputState in
                if self?.validate(nickName: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.inputStates[3] = $0
            }
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.inputStates[4] = $0
            }
            .store(in: &cancellables)
        
        $birthDate
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .map { [weak self] newValue -> InputState in
                if self?.validate(birthDate: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.inputStates[5] = $0
            }
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
            .sink { [weak self] in
                self?.inputStates[6] = $0
            }
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
            .sink { [weak self] in
                self?.inputStates[7] = $0
            }
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
            .sink { [weak self] in
                self?.inputStates[8] = $0
            }
            .store(in: &cancellables)
        
        $phoneNumber
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .map { [weak self] newValue -> InputState in
                if self?.validate(phoneNumber: newValue) == true {
                    return .valid
                }
                return .invalid
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.inputStates[9] = $0
            }
            .store(in: &cancellables)
        
        $detailAddress
            .dropFirst(2)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { newValue -> InputState in
                if (1...200) ~= newValue.count {
                    return .valid
                }
                return .invalid
            }
            .sink { [weak self] in
                self?.inputStates[10] = $0
            }
            .store(in: &cancellables)
        
        $address
            .combineLatest($postCode)
            .dropFirst()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { newValue -> InputState in
                if !newValue.0.isEmpty && !newValue.1.isEmpty {
                    return .valid
                }
                return .invalid
            }
            .sink { [weak self] in
                self?.inputStates[10] = $0
            }
            .store(in: &cancellables)
    }
}
