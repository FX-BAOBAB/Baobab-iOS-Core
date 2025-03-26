//
//  TabBarViewController.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import UIKit
import SwiftUI

final class TabBarViewController: UITabBarController {
    private let tradeArticleTableViewController: TradeArticleTableViewController = .init(
        viewModel: TradeArticleTableViewModel()
    )
    private lazy var plusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .accent
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .highlighted)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.addTarget(self, action: #selector(didPlusButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(didPlusButtonTouchUp(_:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewControllers([tradeArticleTableViewController], animated: true)
        setupTabBar()
        setupLayout()
    }
    
    private func setupTabBar() {
        tradeArticleTableViewController.tabBarItem.image = UIImage(systemName: "house")
        tradeArticleTableViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        tradeArticleTableViewController.tabBarItem.title = "홈"
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .black
    }
    
    private func setupLayout() {
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(tabBar.snp.top).offset(-16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TabBarViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}

extension TabBarViewController {
    @objc private func didPlusButtonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .accent.withAlphaComponent(0.7)
    }
    
    @objc private func didPlusButtonTouchUp(_ sender: UIButton) {
        sender.backgroundColor = .accent
        let destination = UIHostingController(rootView: TradeArticleForm(viewModel: TradeArticleFormViewModel()))
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true)
    }
}

#Preview {
    TabBarViewController()
        .makePreview()
}
