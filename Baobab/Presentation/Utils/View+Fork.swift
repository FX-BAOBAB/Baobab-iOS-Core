//
//  View+Fork.swift
//  Baobab
//
//  Created by 이정훈 on 2/9/25.
//

import SwiftUI

extension View {
    func fork<V: View>(@ViewBuilder _ merge: (Self) -> V) -> V {
        merge(self)
    }
}
