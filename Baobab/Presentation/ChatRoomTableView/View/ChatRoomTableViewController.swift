//
//  ChatRoomTableViewController.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import UIKit
import SwiftUI
import RxSwift

final class ChatRoomTableViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension    //동적 Heigth 지정
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.delegate = self
        return tableView
    }()
    let navigationBar: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "채팅"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    let viewModel: ChatRoomTableViewModel
    
    init(viewModel: ChatRoomTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupLayout()
        bind()
//        setupNavigationItem()
        viewModel.fetchChatRooms()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.task?.cancel()
    }

}

extension ChatRoomTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ChatRoomViewController(
            navigationTitle: viewModel.chatRooms.value[indexPath.row].title,
            chatRoomId: viewModel.chatRooms.value[indexPath.row].id
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
}

#Preview {
    ChatRoomTableViewController(viewModel: ChatRoomTableViewModel())
        .makePreview()
}
