//
//  ImageData.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import Foundation

struct ImageData: Identifiable {
    let id: String
    let imageURL: URL?
}

#if DEBUG
extension ImageData {
    static var sample: ImageData {
        ImageData(id: UUID().uuidString,
                  imageURL: URL(string: "https://baobab.run/article-service/open-api/images/53edc0be-e824-4b38-8c10-7556e6b4f557.png"))
    }
}
#endif
