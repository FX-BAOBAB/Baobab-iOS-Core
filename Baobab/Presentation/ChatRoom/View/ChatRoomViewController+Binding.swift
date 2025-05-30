//
//  ChatRoomViewController+Binding.swift
//  Baobab
//
//  Created by 이정훈 on 4/8/25.
//

import Foundation
import RxCocoa
import RxSwift

extension ChatRoomViewController {
    func bind() {
        inputTextView.rx
            .didChange    //UITextView의 텍스트가 변경되면 호출
            .bind(with: self) { owner, _ in
                let size = CGSize(
                    width: owner.inputTextView.frame.width,
                    height: .infinity
                )
                let estimatedSize = owner.inputTextView.sizeThatFits(size)    //입력된 TextView의 크기 계산
                let isMaxHeight = estimatedSize.height >= 89
                /*
                 1번째 라인: 34.0
                 2번째 라인: 47.6
                 3번째 라인: 61.6
                 4번째 라인: 75.3
                 5번째 라인: 89.0
                 */
                
                guard isMaxHeight != owner.inputTextView.isScrollEnabled else { return }
                
                owner.inputTextView.isScrollEnabled = isMaxHeight
                owner.inputTextView.setNeedsUpdateConstraints()
            }
            .disposed(by: disposeBag)
        
        viewModel.messages
            .observe(on: MainScheduler.instance)
            .bind(to: messageTableView.rx.items) { tableView, index, item in
                if !item.isMine {
                    switch item.messageType {
                    case .textWithProfile:
                        let cell = tableView.dequeueReusableCell(withIdentifier: LeftProfileMessageTableCell.reuseIdentifier, for: IndexPath(item: index, section: 0)) as! LeftProfileMessageTableCell
                        cell.configure(item)
                        
                        return cell
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMessageTableCell.reuseIdentifier, for: IndexPath(item: index, section: 0)) as! LeftMessageTableCell
                        cell.configure(item)
                        
                        return cell
                    }
                } else if item.isLoading {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LoadingRightMessageTableViewCell.reuseIdentifier, for: IndexPath(item: index, section: 0)) as! LoadingRightMessageTableViewCell
                    cell.configure(item)
                    cell.activityIndicator.startAnimating()
                    
                    return cell
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: RightMessageTableCell.reuseIdentifier, for: IndexPath(item: index, section: 0)) as! RightMessageTableCell
                cell.configure(item)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.messages
            .skip(1)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                if !$0.isEmpty && self?.viewModel.isFirstConnection == true {
                    self?.messageTableView.scrollToRow(at: IndexPath(row: $0.count - 1, section: 0), at: .bottom, animated: false)
                    self?.viewModel.isFirstConnection = false
                } else if $0.count > 20 {
                    self?.messageTableView.scrollToRow(at: IndexPath(row: 21, section: 0), at: .top, animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        messageTableView.rx.willDisplayCell
            .subscribe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] cell, indexPath in
                guard let self else { return }
                
                if indexPath.row == 0 {
                    let message = viewModel.messages.value[0]
                    viewModel.fetchMessages(before: message.sentDate + "T" + message.sentTime)
                }
            })
            .disposed(by: disposeBag)
    }
}
