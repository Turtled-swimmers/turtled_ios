import SwiftUI
import UIKit
import PhotosUI
import MobileCoreServices


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedVideoURL: URL?
    @Binding var selectedImage: UIImage    //선택된 이미지를 bindging 형식으로 저장
    @Binding var sourceType: UIImagePickerController.SourceType // Bind the source type
    
    @Environment(\.presentationMode) private var presentationMode    //photo 라이브러리 해지를 위한 변수

    
    // UIImagePickerControllerDelegate
    // 조정
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Handle image selection
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            // Handle video selection
            if let videoURL = info[.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        picker.sourceType = sourceType // Use the source type provided
        return picker
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // The source type may need to be updated depending on user actions.
        uiViewController.sourceType = sourceType
    }
}
