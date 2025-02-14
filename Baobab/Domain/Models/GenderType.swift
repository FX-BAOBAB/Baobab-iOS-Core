//
//  GenderType.swift
//  Baobab
//
//  Created by 이정훈 on 2/14/25.
//

import Foundation

enum GenderType: String, CaseIterable {
    case male = "남성"
    case female = "여성"
    
    var paramValue: String {
        switch self {
        case .male:
            return "MALE"
        case .female:
            return "FEMALE"
        }
    }
}
