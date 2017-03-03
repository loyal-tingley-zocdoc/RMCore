//
//  UIImage+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/30/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public extension UIImage {
    public func sizeMultiple(sizeMultiple: CGFloat = 8) -> UIImage? {
        let width = ceil(self.size.width / sizeMultiple) * sizeMultiple
        let height = ceil(self.size.height / sizeMultiple) * sizeMultiple
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
