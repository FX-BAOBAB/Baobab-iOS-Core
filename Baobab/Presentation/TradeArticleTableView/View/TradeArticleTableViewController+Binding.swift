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
        
        tableView.rx.willDisplayCell
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] cell, indexPath in
                guard let self, viewModel.articles.value.count >= 20 else { return }
                
                if (viewModel.isLoading.value == false) && (indexPath.row == viewModel.articles.value.count - 1) {
                    viewModel.fetchNextPage()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                if $0 {
                    self?.tableView.tableFooterView?.isHidden = false
                } else {
                    self?.tableView.tableFooterView?.isHidden = true
                }
            }
            .disposed(by: disposeBag)
    }
}
