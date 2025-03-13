//
//  TradeArticleTableViewController.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import UIKit
import SwiftUI
import RxSwift

final class TradeArticleTableViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100    //Cell height가 결정되기 전 임시 height
        tableView.rowHeight = UITableView.automaticDimension    //동적 height 설정
        return tableView
    }()
    let navigationBar: UIView = UIView(frame: .zero)
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Baobab"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    let viewModel: TradeArticleTableViewModel
    let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: TradeArticleTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupLayout()
        bind()
        viewModel.fetchArticles()
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.task?.cancel()
    }
}

extension TradeArticleTableViewController: UITableViewDelegate {
    
}

#Preview {
    TradeArticleTableViewController(viewModel: TradeArticleTableViewModel())
        .makePreview()
}
