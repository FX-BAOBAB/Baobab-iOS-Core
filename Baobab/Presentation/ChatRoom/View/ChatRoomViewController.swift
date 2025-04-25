//
//  ChatRoomViewController.swift
//  Baobab
//
//  Created by 이정훈 on 4/8/25.
//

import UIKit
import SwiftUI
import RxSwift

final class ChatRoomViewController: UIViewController {
    let messageTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100    //cell height가 설정되기 전 임시 크기
        tableView.rowHeight = UITableView.automaticDimension    //동적 Height 설정
        tableView.separatorStyle = .none
        tableView.register(LeftMessageTableCell.self, forCellReuseIdentifier: LeftMessageTableCell.reuseIdentifier)
        tableView.register(RightMessageTableCell.self, forCellReuseIdentifier: RightMessageTableCell.reuseIdentifier)
        tableView.register(LeftProfileMessageTableCell.self, forCellReuseIdentifier: LeftProfileMessageTableCell.reuseIdentifier)
        
        return tableView
    }()
    lazy var inputTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .gray1
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.cornerRadius = 10
        textView.isEditable = true
        textView.isScrollEnabled = false    //높이 설정을 위해 스크롤 방지
        textView.font = .preferredFont(forTextStyle: .body)
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.delegate = self
        
        return textView
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .accent
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.setImage(UIImage(systemName: "arrow.up"), for: .highlighted)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didSendButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(didSendButtonTouchUp(_:)), for: .touchUpInside)
        
        return button
    }()
    let disposeBag: DisposeBag = .init()
    private let placeholder: String = "메시지 입력"
    let viewModel: ChatRoomViewModel
    let navigationTitle: String
    
    init(
        viewModel: ChatRoomViewModel,
        navigationTitle: String
    ) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        setupLayout()
        bind()
        adjustForKeyboard()
        setupNavigationBar()
        viewModel.fetchMessages()
        viewModel.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disconnect()
        viewModel.task?.cancel()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatRoomViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension ChatRoomViewController {
    private func adjustForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardShiftAmount = keyboardFrame.height - view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.inputTextView.transform = CGAffineTransform(translationX: 0, y: -keyboardShiftAmount)
            self?.sendButton.transform = CGAffineTransform(translationX: 0, y: -keyboardShiftAmount)
            self?.messageTableView.transform = CGAffineTransform(translationX: 0, y: -keyboardShiftAmount)
        }
    }
    
    @objc private func didSendButtonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .accent.withAlphaComponent(0.7)
    }
    
    @objc private func didSendButtonTouchUp(_ sender: UIButton) {
        sender.backgroundColor = .accent
    }
}

#Preview {
    ChatRoomViewController(
        viewModel: ChatRoomViewModel(articleId: "12345", chatRoomId: "12345"),
        navigationTitle: "테스트"
    )
    .makePreview()
}
