//
//  TradeArticleTableViewController+Binding.swift
//  Baobab
//
//  Created by 이정훈 on 3/13/25.
//

import Foundation
import RxSwift

extension TradeArticleTableViewController {
    func bind() {
        viewModel.articles
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tableView, index, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TradeArticleTableViewCell.reuseIdentifier, for: IndexPath(row: index, section: 0)) as! TradeArticleTableViewCell
                cell.configure(with: item)
                return cell
            }
            .disposed(by: disposeBag)
    }
}
