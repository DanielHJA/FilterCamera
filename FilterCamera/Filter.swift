//
//  Filter.swift
//  FilterCamera
//
//  Created by Daniel Hjärtström on 2020-03-20.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum Filter: String {
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case instant = "CIPhotoEffectInstant"
    case mono = "CIPhotoEffectMono"
    case noir = "CIPhotoEffectNoir"
    case process = "CIPhotoEffectProcess"
    case tonal = "CIPhotoEffectTonal"
    case transfer =  "CIPhotoEffectTransfer"
}

extension UIImage {
    func applyFilter(filter: Filter) -> UIImage? {
        guard let filter = CIFilter(name: filter.rawValue) else { return nil }
        let ciInput = CIImage(image: self)
        filter.setValue(ciInput, forKey: "inputImage")
        guard let ciOutput = filter.outputImage else { return nil }
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
    }
}
