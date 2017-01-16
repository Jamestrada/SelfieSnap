//
//  FilteredImageBuilder.swift
//  FaceSnap
//
//  Created by James Estrada on 11/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

// take an input image, apply filter, and output a second image
final class FilteredImageBuilder {
   private struct PhotoFilter {
        
        static let ColorClamp = "CIColorClamp"
        static let ColorControls = "CIColorControls"
        static let PhotoEffectInstant = "CIPhotoEffectInstant"
        static let PhotoEffectProcess = "CIPhotoEffectProcess"
        static let PhotoEffectNoir = "CIPhotoEffectNoir"
        static let Sepia = "CISepiaTone"
        
        static func defaultFilters() -> [CIFilter] {
            
            // Color Clamp
            let colorClamp = CIFilter(name: PhotoFilter.ColorClamp)!
            // key-value-coding(KVC): accessing a property of an object through a string at runtime
            colorClamp.setValue(CIVector(x:0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
            colorClamp.setValue(CIVector(x:0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
            
            // Color Controls
            let colorControls = CIFilter(name: PhotoFilter.ColorControls)!
            colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
            
            // Photo Effects
            let photoEffectInstant = CIFilter(name: PhotoFilter.PhotoEffectInstant)!
            let photoEffectProcess = CIFilter(name: PhotoFilter.PhotoEffectProcess)!
            let photoEffectNoir = CIFilter(name: PhotoFilter.PhotoEffectNoir)!
            
            // Sepia
            let sepia = CIFilter(name: PhotoFilter.Sepia)!
            sepia.setValue(0.7, forKey: kCIInputIntensityKey)
            
            return [colorClamp, colorControls, photoEffectInstant, photoEffectProcess, photoEffectNoir, sepia]
        }
    }
    
    private let image: UIImage
    private let context: CIContext
    
    init(context: CIContext, image: UIImage) {
        self.context = context
        self.image = image
    }
    
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.map { image(self.image, withFilter: $0) }
    }
    
    func image(image: UIImage, withFilter filter: CIFilter) -> CIImage {
        let inputImage = image.CIImage ?? CIImage(image: image)!
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        let outputImage = filter.outputImage!
        
        return outputImage.imageByCroppingToRect(inputImage.extent)
    }
}
































