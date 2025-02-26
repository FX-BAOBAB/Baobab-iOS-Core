//
//  TabBarViewController.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import UIKit
import SwiftUI

final class TabBarViewController: UITabBarController {
    private let tradeArticleTableViewController: TradeArticleTableViewController = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewControllers([tradeArticleTableViewController], animated: true)
        setupTabBar()
    }
    
    private func setupTabBar() {
        tradeArticleTableViewController.tabBarItem.image = UIImage(systemName: "house")
        tradeArticleTableViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        tradeArticleTableViewController.tabBarItem.title = "홈"
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

#Preview {
    TabBarViewController()
        .makePreview()
}
