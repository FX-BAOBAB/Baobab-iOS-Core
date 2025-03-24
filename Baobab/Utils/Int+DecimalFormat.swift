//
//  Int+DecimalFormat.swift
//  Baobab
//
//  Created by 이정훈 on 3/24/25.
//

import Foundation

extension Int {
    var commaFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
