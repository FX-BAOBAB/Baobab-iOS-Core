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
    
    var paramValue: String {
        get throws {
            switch self {
            case .kt:
                return "KT"
            case .ktMVNO:
                return "KT_MVNO"
            case .skt:
                return "SKT"
            case .sktMVNO:
                return "SKT_MVNO"
            case .lgUPlus:
                return "LGU_PLUS"
            case .lgUPlusMVNO:
                return "LGU_PLUS_MVNO"
            default:
                throw SignupInputError.invalidCarrierType
            }
        }
    }
}
