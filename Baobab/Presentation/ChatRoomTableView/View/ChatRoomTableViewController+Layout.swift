//
//  ChatRoomTableViewController+Layout.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Foundation
import UIKit

extension ChatRoomTableViewController {
    func setupLayout() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(navigationBar.snp.leading).offset(16)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
//    func setupNavigationItem() {
//        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        backBarButtonItem.tintColor = .black
//        navigationItem.backBarButtonItem = backBarButtonItem
//    }
}
