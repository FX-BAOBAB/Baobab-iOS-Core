//
//  CarrierType.swift
//  Baobab
//
//  Created by 이정훈 on 2/14/25.
//

import Foundation

enum CarrierType: String, CaseIterable {
    case none = "통신사를 선택하세요."
    case kt = "KT"
    case skt = "SKT"
    case lgUPlus = "LG U+"
    case ktMVNO = "KT 알뜰폰"
    case sktMVNO = "SKT 알뜰폰"
    case lgUPlusMVNO = "LG U+ 알뜰폰"
    
    var fileName: String? {
        switch self {
        case .kt, .ktMVNO:
            return "KT_Logo"
        case .skt, .sktMVNO:
            return "SKT_Logo"
        case .lgUPlus, .lgUPlusMVNO:
            return "LG_U+_Logo"
        default:
            return nil
        }
    }
}
