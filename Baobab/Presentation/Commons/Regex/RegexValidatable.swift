//
//  RegexValidatable.swift
//  Baobab
//
//  Created by 이정훈 on 2/13/25.
//

import Foundation

protocol RegexValidatable {
    func validate(email: String) -> Bool
    func validate(password: String) -> Bool
    func validate(nickName: String) -> Bool
    func validate(name: String) -> Bool
    func validate(phoneNumber: String) -> Bool
    func validate(birthDate: String) -> Bool
}

extension RegexValidatable {
    /// Email 정규식 검사
    ///
    /// Email은
    /// @ 앞 최대 50자,
    /// @ 뒤 최대 50자,
    /// 알파벳  a-z, A-Z, 숫자 0-9, 그리고 @와 .만 사용 가능
    ///
    /// - Returns: 입력 값이 정규식과 일치하는지 boolean 값 반환
    func validate(email: String) -> Bool {
        let regex = "^[A-Za-z0-9]{1,50}@[A-Za-z0-9.-]{1,50}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    /// Password 정규식 검사
    ///
    /// Password는
    /// 대소문자, 특수문자 포함 최소 8자, 최대 100자까지 허용
    /// - \, {, } , (, ), <, >, $, %, ^, &, *, _, =, |, ` 특수문자는 제외
    /// - Returns: 입력 값이 정규식과 일치하는지 boolean 값 반환
    func validate(password: String) -> Bool {
        let regex = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#?:;"'~\[\]/+\-])[^\s\\{}()<>\$%^&*_=|`]{8,100}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    /// NickName 정규식 검사
    ///
    /// NickName은
    /// 최소 길이는 2자 이며, 최대 50자까지 허용
    /// - \, {, } , (, ), <, >, $, %, ^, &, *, _, =, |, ` 특수문자는 제외
    /// - Returns: 입력 값이 정규식과 일치하는지 boolean 값 반환
    func validate(nickName: String) -> Bool {
        let regex = #"^[^\\{}()<>\$%^&*_=|`]{2,50}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickName)
    }
    
    /// Name 정규식 검사
    ///
    /// Name은
    /// 최소 1자, 최대 50자까지 허용
    /// - 특수문자 제외, 한글 또는 영문만 허용
    /// - Returns: 입력 값이 정규식과 일치하는지 boolean 값 반환
    func validate(name: String) -> Bool {
        let regex = "^[가-힣A-Za-z]{1,50}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: name)
    }
    
    /// phoneNumber 정규식 검사
    ///
    /// phoneNumber는
    /// 01X-XXXX-XXXX 형태로 입력 가능
    /// - Returns: 입력 값이 정규식과 일치하는지 boolean 값 반환
    func validate(phoneNumber: String) -> Bool {
        let regex = #"^01[016789]-\d{3,4}-\d{4}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phoneNumber)
    }
    
    /// birthDate 정규식 검사
    ///
    /// BirthDate는
    /// XXXX-XX-XX 형식으로 입력 가능
    /// - Returns: 입력 값이 정규식과 일치하는지 boolean 값 반환
    func validate(birthDate: String) -> Bool {
        let regex = #"^\d{4}-\d{2}-\d{2}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: birthDate)
    }
}
