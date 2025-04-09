//
//  ChatRoomMenuViewController.swift
//  Baobab
//
//  Created by 이정훈 on 4/9/25.
//

import UIKit
import SwiftUI

final class ChatRoomMenuViewController: UIViewController {
    private let chatRoomId: String
    
    init(chatRoomId: String) {
        self.chatRoomId = chatRoomId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        setupLayout()
        
        let viewController = UIHostingController(
            rootView: ChatRoomMenu(viewModel: ChatRoomMenuViewModel(), chatRoomId: chatRoomId)
        )
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
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

extension ChatRoomMenuViewController {
    private func setupLayout() {
        //LeftNavigationItem
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

#Preview {
    NavigationStack {
        ChatRoomMenuViewController(chatRoomId: "12345")
            .makePreview()
    }
}
