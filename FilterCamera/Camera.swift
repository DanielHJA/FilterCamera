//
//  Camera.swift
//  FilterCamera
//
//  Created by Daniel Hjärtström on 2020-03-20.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol CameraDelegate: class {
    func didFinishPickingImage(_ image: UIImage)
    func imageSavedSuccess()
    func imageSaveFailure(_ error: Error)
}

class Camera: NSObject {
    
    var filter: Filter?
    var sourceType: UIImagePickerController.SourceType = .camera
    var allowsEditing: Bool = false
    var cameraCaptureMode: UIImagePickerController.CameraCaptureMode = .photo
    var cameraDevice: UIImagePickerController.CameraDevice = .rear
    
    weak var delegate: CameraDelegate?
    private weak var controller: UIViewController?
    
    private var imagePickerViewController = UIImagePickerController()
    private var coverViewController: CoverViewController?
    private var image: UIImage?
    
    init(_ controller: UIViewController) {
        super.init()
        self.controller = controller
        configureImagePickerViewController()
        configureObservers()
    }
    
    private func configureImagePickerViewController() {
        imagePickerViewController.sourceType = sourceType
        imagePickerViewController.allowsEditing = allowsEditing
        imagePickerViewController.cameraCaptureMode = cameraCaptureMode
        imagePickerViewController.cameraDevice = cameraDevice
        imagePickerViewController.delegate = self
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
}

// MARK: - Overlays
extension Camera {
    
    @objc private func orientationChanged() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight, .faceDown, .faceUp:
            presentCoverController()
        default:
            dismissCoverController()
        }
    }
    
    private func presentCoverController() {
        coverViewController = CoverViewController()
        coverViewController?.modalTransitionStyle = .crossDissolve
        imagePickerViewController.present(coverViewController!, animated: true, completion: nil)
    }
    
    private func dismissCoverController() {
        imagePickerViewController.dismiss(animated: true, completion: nil)
        coverViewController = nil
    }
    
}

// MARK: - External
extension Camera {
    func presentCamera() {
        controller?.present(imagePickerViewController, animated: true)
    }
}

// MARK: - Saving
extension Camera {
    
    func saveToRoll() {
        guard let image = image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("There was an error saving the image: \(error)")
            delegate?.imageSaveFailure(error)
            return
        }
        delegate?.imageSavedSuccess()
        self.image = nil
    }
    
}

// MARK: - Delegates and Processing Method
extension Camera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        print("User cancelled")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image")
            return
        }
        
        self.image = image
        processImage()
    }
    
    private func processImage() {
        if let filter = filter {
            image = image?.applyFilter(filter: filter)
        }
        
        if let image = image {
            delegate?.didFinishPickingImage(image)
        }
    }
    
}
