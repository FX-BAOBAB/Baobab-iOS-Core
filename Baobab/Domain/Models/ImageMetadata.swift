//
//  ImageMetadata.swift
//  Baobab
//
//  Created by 이정훈 on 2/26/25.
//

import Foundation

struct ImageMetadata: Identifiable {
    let id: String
    let imageURL: URL?
}

#if DEBUG
extension ImageMetadata {
    static var sample: ImageMetadata {
        ImageMetadata(id: UUID().uuidString,
                  imageURL: URL(string: "https://baobab.run/article-service/open-api/images/53edc0be-e824-4b38-8c10-7556e6b4f557.png"))
    }
}
#endif
