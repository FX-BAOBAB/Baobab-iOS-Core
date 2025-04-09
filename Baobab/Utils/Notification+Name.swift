//
//  Notification+Name.swift
//  Baobab
//
//  Created by 이정훈 on 3/5/25.
//

import Foundation

extension Notification.Name {
    static let refreshTokenExpired = Notification.Name("refreshTokenExpired")
    static let loginSuccess = Notification.Name("loginSuccess")
    static let navigateToRoot = Notification.Name("navigateToRoot")
    static let chatRoomDidExit = Notification.Name("chatRoomDidExit")
}
