//
//  ViewModifier.swift
//  Baobab
//
//  Created by 이정훈 on 2/14/25.
//

import SwiftUI

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

fileprivate struct StateModifier: ViewModifier {
    @Binding var inputState: InputState
    let message: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            content
            
            if inputState == .invalid {
                HStack(spacing: 3) {
                    Image(systemName: "info.circle")
                    
                    Text(message)
                }
                .font(.system(size: 11))
                .foregroundStyle(.red)
            } else {
                Color.clear
                    .frame(height: 13)
            }
        }
        .animation(.easeInOut, value: inputState)
    }
}

fileprivate struct GrayBorderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(.gray)
            }
    }
}

extension View {
    func title(_ title: String, isRequired: Bool = true) -> some View {
        modifier(TitleModifier(title: title, isRequired: isRequired))
    }
    
    func state(_ inputState: Binding<InputState>, message: String) -> some View {
        modifier(StateModifier(inputState: inputState, message: message))
    }
    
    func grayBorder() -> some View {
        modifier(GrayBorderModifier())
    }
}
