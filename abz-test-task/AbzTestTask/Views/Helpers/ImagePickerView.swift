//
//  ImagePickerView.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI

/// A SwiftUI wrapper for UIImagePickerController to select images.
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Environment(\.dismiss) var dismiss
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(picker: self)
    }
}

/// Coordinator to handle image picker delegate methods.
class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }  // Get the selected image
        self.picker.selectedImageData = selectedImage.jpegData(compressionQuality: 0.7)  // Store the image data
        self.picker.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss()
    }
}
