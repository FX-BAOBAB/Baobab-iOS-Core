//
//  ChatRoomVIewController+Layout.swift
//  Baobab
//
//  Created by 이정훈 on 4/8/25.
//

import Foundation
import UIKit
import SwiftUI

extension ChatRoomViewController {
    func setupLayout() {

        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.lessThanOrEqualTo(89)
        }
        
        view.addSubview(messageTableView)
        messageTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(inputTextView.snp.top).offset(-10)
        }
    }
    
    func setupNavigationBar() {
        //Title
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = navigationTitle
        
        //LeftNavigationItem
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        navigationItem.leftBarButtonItem = backButton
        
        //RightNavigationItem
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(menuButtonDidTap)
        )
        navigationItem.rightBarButtonItem = menuButton
    }
    
    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func menuButtonDidTap() {
        let viewController = ChatRoomMenuViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
