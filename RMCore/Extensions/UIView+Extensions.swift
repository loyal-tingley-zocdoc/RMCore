//
//  UIView+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set (newX) {
            frame = CGRect(origin: CGPoint(x: newX, y: y), size: frame.size)
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set (newY) {
            frame = CGRect(origin: CGPoint(x: x, y: newY), size: frame.size)
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set (newWidth) {
            frame = CGRect(origin: frame.origin, size: CGSize(width: newWidth, height: height))
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set (newHeight) {
            frame = CGRect(origin: frame.origin, size: CGSize(width: width, height: newHeight))
        }
    }
    
    var bottomY: CGFloat {
        get {
            return CGRectGetMaxY(frame)
        }
    }
    
    var rightX: CGFloat {
        get{
            return CGRectGetMaxX(frame)
        }
    }
}
