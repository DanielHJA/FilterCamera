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
    func imageSavedSuccessfully()
}

class Camera: NSObject {

    weak var controller: UIViewController?
    weak var delegate: CameraDelegate?
    
    private var imagePickerViewController = UIImagePickerController()
    private var coverViewController: CoverViewController?
    var filter: Filter?
    private var image: UIImage?
    
    init(_ controller: UIViewController, sourceType: UIImagePickerController.SourceType = .camera, allowsEditing: Bool = false, cameraCaptureMode: UIImagePickerController.CameraCaptureMode = .photo, cameraDevice: UIImagePickerController.CameraDevice = .rear) {
        super.init()
        self.controller = controller
        imagePickerViewController.sourceType = sourceType
        imagePickerViewController.allowsEditing = allowsEditing
        imagePickerViewController.cameraCaptureMode = cameraCaptureMode
        imagePickerViewController.cameraDevice = cameraDevice
        imagePickerViewController.delegate = self
        configureObservers()
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    func presentCamera() {
        controller?.present(imagePickerViewController, animated: true)
    }
    
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
    
    private func processImage() {
        if let filter = filter {
            image = image?.applyFilter(filter: filter)
        }
        
        if let image = image {
            delegate?.didFinishPickingImage(image)
        }
    }
    
    func saveToRoll() {
        guard let image = image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
       guard error == nil else {
          print("There was an error saving the image")
          return
       }
        delegate?.imageSavedSuccessfully()
        self.image = nil
    }
    
}

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
    
}
