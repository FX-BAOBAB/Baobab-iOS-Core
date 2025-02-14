//
//  Errors.swift
//  Baobab
//
//  Created by 이정훈 on 2/14/25.
//

import Foundation

enum SignupInputError: String, Error, CaseIterable {
    case invalidEmail = "올바른 이메일 형식을 입력하세요."
    case invalidPassword = "대문자, 소문자, 특수문자 포함 8자 이상이어야 해요."
    case passwordNotMatch = "비밀번호가 일치하지 않아요."
    case invalidNickName = "2자 이상 50자 이하로 입력해 주세요."
    case invalidName = "1자 이상, 50자 이하로 입력해 주세요."
    case invalidBirthDate = "생년월일 8자리로 입력해 주세요."
    case invalidGenderType = "성별을 선택해 주세요."
    case invalidNationalityType = "국적을 선택해 주세요."
    case invalidCarrierType = "통신사를 선택해 주세요."
    case invalidPhoneNumber = "전화번호 11자리로 입력해 주세요."
    case invalidAddress = "정확한 주소를 입력해 주세요."
}
