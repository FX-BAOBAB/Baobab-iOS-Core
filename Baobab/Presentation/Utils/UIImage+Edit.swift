//
//  UIImage+Edit.swift
//  Baobab
//
//  Created by 이정훈 on 3/26/25.
//

import Foundation
import UIKit

extension UIImage {
    func cropToSquare() -> UIImage {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        let shortestSideLength = min(originalWidth, originalHeight)
        let cropRect = CGRect(
            x: (originalWidth - shortestSideLength) / 2.0,
            y: (originalHeight - shortestSideLength) / 2.0,
            width: shortestSideLength,
            height: shortestSideLength
        ).integral
        
        guard let croppedImage = self.cgImage?.cropping(to: cropRect) else {
            return self
        }
        
        return UIImage(cgImage: croppedImage)
    }
    
    func downScaleToJpegData(maxBytes: UInt) async -> Data? {
        var quality: Double = 1.0
        while quality > 0 {
            guard let jpegData = self.jpegData(compressionQuality: quality) else {
                return nil
            }
            
            if jpegData.count <= maxBytes {
                return jpegData
            }
            
            quality -= 0.1
        }
        
        return nil
    }
    
    func downScaleToJpegData(maxBytes: UInt) -> Data? {
        var quality: Double = 1.0
        while quality > 0 {
            guard let jpegData = self.jpegData(compressionQuality: quality) else {
                return nil
            }
            
            if jpegData.count <= maxBytes {
                return jpegData
            }
            
            quality -= 0.1
        }
        
        return nil
    }
}
