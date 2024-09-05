//
//  PhotoPicker.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 05/09/2024.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let uiImage = image as? UIImage, error == nil else { return }
                    DispatchQueue.main.async {
                        self.parent.selectedImage = uiImage
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
