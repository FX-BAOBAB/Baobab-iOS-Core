//
//  TitleView.swift
//  Baobab
//
//  Created by 이정훈 on 2/12/25.
//

import SwiftUI

struct TitleView: View {
    let title: String
    let isRequired: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Text(title)
                .foregroundStyle(.gray)
            
            if isRequired {
                Text("*")
                    .foregroundStyle(.accent)
            }
        }
        .bold()
        .font(.subheadline)
    }
}

#Preview {
    TitleView(title: "title", isRequired: true)
}
