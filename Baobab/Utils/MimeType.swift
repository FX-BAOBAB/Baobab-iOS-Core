//
//  MimeType.swift
//  Baobab
//
//  Created by 이정훈 on 3/28/25.
//

import Foundation

enum MimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case pdf = "application/pdf"
    case json = "application/json"
    case text = "text/plain"
    case html = "text/html"
    case csv = "text/csv"
    case mp4 = "video/mp4"
    case audio = "audio/mpeg"
    case zip = "application/zip"
    
    func toFileExtension() -> String {
        switch self {
        case .audio:
            return ".mp3"
        case .csv:
            return ".csv"
        case .gif:
            return ".gif"
        case .html:
            return ".html"
        case .jpeg:
            return ".jpeg"
        case .json:
            return ".json"
        case .mp4:
            return ".mp4"
        case .pdf:
            return ".pdf"
        case .png:
            return ".png"
        case .text:
            return ".text"
        case .zip:
            return ".zip"
        }
    }
}
