//
//  UIViewController+Preview.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import UIKit
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
    
    func makePreview() -> some View {
        Preview(viewController: self)
    }
}
