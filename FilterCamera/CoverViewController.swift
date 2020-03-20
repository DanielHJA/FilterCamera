//
//  DarkViewController.swift
//  FilterCamera
//
//  Created by Daniel Hjärtström on 2020-03-20.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class CoverViewController: UIViewController {
    
    private lazy var content: UIView = {
        let temp = UIView()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        temp.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
        return temp
    }()
    
    private lazy var imageView: UIImageView = {
        let temp = UIImageView()
        temp.tintColor = .white
        temp.contentMode = .scaleAspectFit
        content.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        temp.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.5).isActive = true
        temp.widthAnchor.constraint(equalTo: temp.heightAnchor).isActive = true
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        imageView.isHidden = false
        configureObservers()
        orientationChanged()
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    @objc private func orientationChanged() {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            imageView.image = UIImage(systemName: "rotate.right")
        case .landscapeRight:
            imageView.image = UIImage(systemName: "rotate.left")
        case .faceUp:
            imageView.image = UIImage(systemName: "arrow.up.square")
        case .faceDown:
            imageView.image = UIImage(systemName: "arrow.down.square")
        default:
            break
        }
    }

}
