//
//  ParentViewViewController.swift
//  Baobab
//
//  Created by 이정훈 on 4/9/25.
//

import UIKit
import SwiftUI
import Combine

final class ParentViewViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
        addChild(viewController: UIHostingController(
            rootView: LoginForm(viewModel: LoginFormViewModel()))
        )
    }
}

extension ParentViewViewController {
    private func addChild(viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func transform(to newViewController: UIViewController) {
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        
        addChild(viewController: newViewController)
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: .loginSuccess)
            .sink { [weak self] _ in
                let viewController = UINavigationController(rootViewController: TabBarViewController())
                self?.transform(to: viewController)
            }
            .store(in: &cancellables)
    }
}
