//
//  Dictionary+BaseParam.swift
//  Baobab
//
//  Created by 이정훈 on 4/2/25.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    static var baseParam: Self {
        return [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ]
        ]
    }
}
