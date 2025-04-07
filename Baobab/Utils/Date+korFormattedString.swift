//
//  Date+korFormattedString.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Foundation

extension Date {
    var korFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return dateFormatter.string(from: self)
    }
    
    var dotFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
}
