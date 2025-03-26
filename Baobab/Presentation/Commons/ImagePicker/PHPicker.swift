//
//  PHPicker.swift
//  Baobab
//
//  Created by 이정훈 on 3/26/25.
//

import Foundation
import PhotosUI
import SwiftUI

struct PHPicker: UIViewControllerRepresentable {
    @Binding private var selectedImageDataList: [Data]
    @Environment(\.dismiss) private var dismiss
    
    init(selectedImageDataList: Binding<[Data]>) {
        _selectedImageDataList = selectedImageDataList
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PHPicker
        
        init(parent: PHPicker) {
            self.parent = parent
        }
        
        //유저가 선택 또는 뷰를 닫았을 때 호출되는 메서드
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.global(qos: .userInitiated).async {
                        if let image = image as? UIImage, let data = image.cropToSquare().downScaleToJpegData(maxBytes: 1_048_576) {
                            DispatchQueue.main.async {
                                self.parent.selectedImageDataList.append(data)
                                self.parent.dismiss()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.parent.dismiss()
                            }
                        }
                    }
                }
            } else {
                parent.dismiss()
            }
        }
    }
}
