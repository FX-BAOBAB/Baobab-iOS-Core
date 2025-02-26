//
//  TabBarView.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import SwiftUI

struct TabBarView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return TabBarViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
    TabBarView()
        .edgesIgnoringSafeArea(.bottom)
}
