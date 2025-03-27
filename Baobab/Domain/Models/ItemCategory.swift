//
//  ItemCategory.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import Foundation

enum ItemCategory: String, CaseIterable {
    case digitalDevice = "DIGITAL_DEVICES"
    case furniture = "FURNITURE"
    case babyProduct = "BABY_PRODUCTS"
    case clothing = "CLOTHING"
    case electronics = "ELECTRONICS"
    case homeKitchen = "HOME_KITCHEN"
    case sportsLeisure = "SPORTS_LEISURE"
    case beauty = "BEAUTY"
    case plant = "PLANT"
    case processedFood = "PROCESSED_FOOD"
    case healthSupplements = "HEALTH_SUPPLEMENTS"
    case books = "BOOKS"
    case other = "OTHER"
    
    var korString: String {
        switch self {
        case .digitalDevice:
            return "디지털 기기"
        case .furniture:
            return "가구"
        case .babyProduct:
            return "유아용품"
        case .clothing:
            return "의류"
        case .electronics:
            return "전자제품"
        case .homeKitchen:
            return "생활용품 및 주방용품"
        case .sportsLeisure:
            return "스포츠 및 레저용품"
        case .beauty:
            return "화장품"
        case .plant:
            return "식물"
        case .processedFood:
            return "가공식품"
        case .healthSupplements:
            return "건강기능식품"
        case .books:
            return "도서"
        default:
            return "기타"
        }
    }
}
