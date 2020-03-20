//
//  ViewController.swift
//  FilterCamera
//
//  Created by Daniel Hjärtström on 2020-03-20.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var cameraBarButtonItem: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(openCamera))
        return temp
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveToCameraRoll))
        return temp
    }()
    
    private lazy var imageView: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFit
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temp.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        temp.widthAnchor.constraint(equalTo: temp.heightAnchor, multiplier: 0.7).isActive = true
        return temp
    }()
    
    private lazy var camera: Camera = {
        let temp = Camera(self)
        temp.filter = .mono
        temp.delegate = self
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = cameraBarButtonItem
        navigationItem.leftBarButtonItem = saveBarButtonItem
    }

    @objc private func openCamera() {
        camera.presentCamera()
    }
    
    @objc private func saveToCameraRoll() {
        camera.saveToRoll()
    }

}

extension ViewController: CameraDelegate {
    
    func didFinishPickingImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func imageSavedSuccess() {
        let controller = CompletionViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
        imageView.image = nil
    }
    
    func imageSaveFailure(_ error: Error) {
        print(error)
    }
    
}
