//
//  DateAndTimeProvidable.swift
//  Baobab
//
//  Created by 이정훈 on 4/24/25.
//

import Foundation

protocol DateAndTimeProvidable {
    func getDate(from date: String) -> String
    func getTime(from date: String) -> String
}

extension DateAndTimeProvidable {
    func getDate(from date: String) -> String {
        return date.split(separator: "T").map { String($0) }.first ?? ""
    }
    
    func getTime(from date: String) -> String {
        return date.split(separator: "T").map { String($0) }.last?.split(separator: ":")[0...1].joined(separator: ":") ?? ""
    }
}
