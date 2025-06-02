//
//  Bundle+EndPoints.swift
//  Baobab
//
//  Created by 이정훈 on 2/20/25.
//

import Foundation

extension Bundle {
    private var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var signupEndPoint: String? {
        guard let resource, let url = resource["Singup_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var loginEndPoint: String? {
        guard let resource, let url = resource["Login_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var tradeArticleEndPoint: String? {
        guard let resource, let url = resource["TradeArticle_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var reissueEndPoint: String? {
        guard let resource, let url = resource["Reissue_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var chatEndPoint: String? {
        guard let resource, let url = resource["Chat_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var userEndPoint: String? {
        guard let resource, let url = resource["User_URL"] as? String else {
            return nil
        }
        
        return url
    }
}
