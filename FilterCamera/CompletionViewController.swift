//
//  CompletionViewController.swift
//  FilterCamera
//
//  Created by Daniel Hjärtström on 2020-03-20.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class CompletionViewController: UIViewController {
    
    private lazy var content: UIView = {
        let temp = UIView()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temp.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        temp.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: temp.widthAnchor, multiplier: 0.5).isActive = true
        return temp
    }()

    private lazy var imageView: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage(systemName: "folder.badge.plus")
        temp.tintColor = .white
        temp.contentMode = .scaleAspectFit
        content.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.5).isActive = true
        temp.widthAnchor.constraint(equalTo: temp.heightAnchor).isActive = true
        return temp
    }()
    
    private lazy var label: UILabel = {
        let temp = UILabel()
        temp.text = "Image saved successfully"
        temp.textColor = UIColor.white
        temp.textAlignment = .center
        temp.numberOfLines = 2
        temp.minimumScaleFactor = 0.7
        temp.adjustsFontSizeToFitWidth = true
        temp.font = UIFont.systemFont(ofSize: 25.0, weight: .medium)
        content.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.0).isActive = true
        temp.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        imageView.isHidden = false
        label.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
