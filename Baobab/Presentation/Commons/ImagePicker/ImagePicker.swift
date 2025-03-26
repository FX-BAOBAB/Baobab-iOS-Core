//
//  ImagePicker.swift
//  Baobab
//
//  Created by 이정훈 on 3/24/25.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding private var selectedImageDataList: [Data]
    @Environment(\.dismiss) private var dismiss
    
    init(_ selectedImageDataList: Binding<[Data]>) {
        _selectedImageDataList = selectedImageDataList
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                parent.dismiss()
                return
            }
            
            Task(priority: .userInitiated) {
                let data = await uiImage.cropToSquare().downScaleToJpegData(maxBytes: 1_048_576)
                if let data {
                    parent.selectedImageDataList.append(data)
                }
                parent.dismiss()
            }
        }
    }
}
