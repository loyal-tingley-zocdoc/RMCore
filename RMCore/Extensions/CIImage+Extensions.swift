//
//  CIImage+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/30/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public extension CIImage {
    public func overlay(rectangle: CIRectangleFeature, color: UIColor = UIColor(hex: 0xfff04b, alpha: 0.2)) -> CIImage {
        var overlay = CIImage(color: CIColor(cgColor: color.cgColor))
        
        overlay = overlay.cropping(to: extent)
        
        let parameters: [String: Any] = ["inputExtent": CIVector(cgRect: extent),
                                         "inputTopLeft": CIVector(cgPoint: rectangle.topLeft),
                                         "inputTopRight": CIVector(cgPoint: rectangle.topRight),
                                         "inputBottomLeft": CIVector(cgPoint: rectangle.bottomLeft),
                                         "inputBottomRight": CIVector(cgPoint: rectangle.bottomRight)]
        
        overlay = overlay.applyingFilter("CIPerspectiveTransformWithExtent", withInputParameters: parameters)
        
        return overlay.compositingOverImage(self)
    }
    
    public func constrastFilter(contrast: Float = 1.1) -> CIImage? {
        let parameters: [String: Any] = ["inputContrast": contrast,
                                         kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CIColorControls", withInputParameters: parameters)
        
        return filter?.outputImage
    }
    
    public func blackWhiteFilter(contrast: Float = 1.14, brightness: Float = 0, saturation: Float = 0) -> CIImage? {

        let parameters: [String: Any] = ["inputContrast": contrast,
                                         "inputBrightness": brightness,
                                         "inputSaturation": saturation,
                                         kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CIColorControls", withInputParameters: parameters)
        
        return filter?.outputImage
    }
    
    public func perspectiveCorrected(for rectangle: CIRectangleFeature) -> CIImage {
        let parameters: [String: Any] = ["inputTopLeft": CIVector(cgPoint: rectangle.topLeft),
                                         "inputTopRight": CIVector(cgPoint: rectangle.topRight),
                                         "inputBottomLeft": CIVector(cgPoint: rectangle.bottomLeft),
                                         "inputBottomRight": CIVector(cgPoint: rectangle.bottomRight)]
        
        return applyingFilter("CIPerspectiveCorrection", withInputParameters: parameters)
    }
    
    public func scaleFilter(scale: Float) -> CIImage? {
        let parameters: [String: Any] = ["inputScale": scale,
                                         "inputAspectRatio": 1.0,
                                         kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CILanczosScaleTransform", withInputParameters: parameters)
        
        return filter?.outputImage
    }
    
    public func exposureAdjustmentFilter(exposure: Float) -> CIImage? {
        let parameters: [String: Any] = ["inputEV": exposure,
                                         kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CIExposureAdjust", withInputParameters: parameters)
        
        return filter?.outputImage
    }
}
