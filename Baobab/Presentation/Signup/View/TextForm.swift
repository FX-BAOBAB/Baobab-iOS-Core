//
//  TextForm.swift
//  Baobab
//
//  Created by 이정훈 on 2/12/25.
//

import SwiftUI

struct TextForm: View {
    @Binding var text: String
    
    let placeholder: String
    let isSecureText: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        isSecureText: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isSecureText = isSecureText
    }
    
    var body: some View {
        Group {
            if isSecureText {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
            }
        }
        .font(.subheadline)
        .padding()
        .background(.background2)
        .cornerRadius(10)
    }
}

fileprivate struct TitleModifier: ViewModifier {
    let title: String
    let isRequired: Bool
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            TitleView(title: title, isRequired: isRequired)
            
            content
        }
    }
}

extension TextForm {
    func title(_ title: String, isRequired: Bool = false) -> some View {
        modifier(TitleModifier(title: title, isRequired: isRequired))
    }
}

#Preview {
    TextForm(text: .constant(""), placeholder: "placeholder")
        .title("title")
        .keyboardType(.default)
}
