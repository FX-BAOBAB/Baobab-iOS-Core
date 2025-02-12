//
//  PostCodeSearchWebView.swift
//  Baobab
//
//  Created by 이정훈 on 2/12/25.
//

import WebKit
import SwiftUI

struct PostCodeSearchWebView: UIViewRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var roadAddress: String
    @Binding var postCode: String
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: "https://fx-baobab.github.io/DaumKakao_Postcode_Web/") else {
            return WKWebView()
        }
        
        let userContentController = WKUserContentController()
        userContentController.add(context.coordinator, name: "callBackHandler")    //JavaScript Code에서 해당 name을 통해 데이터 전달
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        private var parent: PostCodeSearchWebView
        
        init(parent: PostCodeSearchWebView) {
            self.parent = parent
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let data = message.body as? [String: String] else { return }
            
            //WebView에서 전달된 데이터 처리
            if let roadAddress = data["roadAddress"] {
                parent.roadAddress = roadAddress
            }
            
            if let postCode = data["zonecode"] {
                parent.postCode = postCode
            }
            
            parent.dismiss()
        }
    }
}
