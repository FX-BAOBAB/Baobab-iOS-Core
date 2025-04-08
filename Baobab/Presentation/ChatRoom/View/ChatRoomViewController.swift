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
//    let stackView: UIStackView = {
//        let stackView = UIStackView(frame: .zero)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        
////        stackView.frame.height = UIScreen.main.bounds.height
//        
//        return stackView
//    }()
    let inputContainer: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    let messageTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        
        return tableView
    }()
    let inputTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .gray1
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.cornerRadius = 10
        textView.isEditable = true
        textView.isScrollEnabled = false    //높이 설정을 위해 스크롤 방지
        
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        setupLayout()
        bind()
        adjustForKeyboard()
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

extension ChatRoomViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        let size = CGSize(width: view.frame - 32, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//    }
}

#Preview {
    ChatRoomViewController()
        .makePreview()
}
