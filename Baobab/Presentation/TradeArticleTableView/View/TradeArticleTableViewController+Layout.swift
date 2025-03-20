//
//  TradeArticleTableViewController+Layout.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import Foundation
import SnapKit

extension TradeArticleTableViewController {
    func setupLayout() {
        view.addSubview(navigationBar)
        navigationBar.addSubview(titleLabel)
        view.addSubview(tableView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(navigationBar.snp.left).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
