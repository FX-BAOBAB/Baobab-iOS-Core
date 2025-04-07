//
//  ChatRoomTableViewController+Binding.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import Foundation
import RxCocoa

extension ChatRoomTableViewController {
    func bind() {
        viewModel.chatRooms
            .bind(to: tableView.rx.items) { tableView, index, item in
                print(item)
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.reuseIdentifier, for: IndexPath(row: index, section: 0)) as! ChatRoomTableViewCell
                cell.configure(with: item)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
}
