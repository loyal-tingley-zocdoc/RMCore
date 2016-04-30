//
//  CIImage+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/30/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public extension CIImage {
    public func imageWithOverlayRectangle(rectangle: CIRectangleFeature, color: UIColor = UIColor(hex: 0xfff04b, alpha: 0.2)) -> CIImage {
        var overlay = CIImage(color: CIColor(CGColor: color.CGColor))
        
        overlay = overlay.imageByCroppingToRect(extent)
        
        let parameters = ["inputExtent": CIVector(CGRect: extent),
                          "inputTopLeft": CIVector(CGPoint: rectangle.topLeft),
                          "inputTopRight": CIVector(CGPoint: rectangle.topRight),
                          "inputBottomLeft": CIVector(CGPoint: rectangle.bottomLeft),
                          "inputBottomRight": CIVector(CGPoint: rectangle.bottomRight)]
        
        overlay = overlay.imageByApplyingFilter("CIPerspectiveTransformWithExtent", withInputParameters: parameters)
        
        return overlay.imageByCompositingOverImage(self)
    }
    
    public func imageWithContrastFilter(contrast: Float = 1.1) -> CIImage? {
        let parameters = ["inputContrast": contrast,
                          kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CIColorControls", withInputParameters: parameters)
        
        return filter?.outputImage
    }
    
    public func imageWithBlackWhiteFilter(contrast: Float = 1.14, brightness: Float = 0, saturation: Float = 0) -> CIImage? {

        let parameters = ["inputContrast": contrast,
                          "inputBrightness": brightness,
                          "inputSaturation": saturation,
                          kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CIColorControls", withInputParameters: parameters)
        
        return filter?.outputImage
    }
    
    public func imageWithPerspectiveCorrectedForRectangle(rectangle: CIRectangleFeature) -> CIImage {
        let parameters = ["inputTopLeft": CIVector(CGPoint: rectangle.topLeft),
                          "inputTopRight": CIVector(CGPoint: rectangle.topRight),
                          "inputBottomLeft": CIVector(CGPoint: rectangle.bottomLeft),
                          "inputBottomRight": CIVector(CGPoint: rectangle.bottomRight)]
        
        return imageByApplyingFilter("CIPerspectiveCorrection", withInputParameters: parameters)
    }
    
    public func imageWithScaleFilter(scale: Float) -> CIImage? {
        let parameters = ["inputScale": scale,
                          "inputAspectRatio": 1.0,
                          kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CILanczosScaleTransform", withInputParameters: parameters)
        
        return filter?.outputImage
    }
    
    public func imageWithExposureAdjustmentFilter(exposure: Float) -> CIImage? {
        let parameters = ["inputEV": exposure,
                          kCIInputImageKey: self]
        
        let filter = CIFilter(name: "CIExposureAdjust", withInputParameters: parameters)
        
        return filter?.outputImage
    }
}