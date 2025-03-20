//
//  UIFont+DynamicFont.swift
//  Baobab
//
//  Created by 이정훈 on 3/20/25.
//

import UIKit

extension UIFont {
    //dynamic font는 유지한채 weight 적용
    static func font(for style: TextStyle, weight: Weight) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        
        return font
    }
}
