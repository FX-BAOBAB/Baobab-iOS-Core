//
//  ChatRoomViewController+Binding.swift
//  Baobab
//
//  Created by 이정훈 on 4/8/25.
//

import Foundation

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
    }
}
