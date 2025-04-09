//
//  ChatRoomVIewController+Layout.swift
//  Baobab
//
//  Created by 이정훈 on 4/8/25.
//

import Foundation

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
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(inputTextView.snp.top).offset(-10)
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = navigationTitle
    }
}
