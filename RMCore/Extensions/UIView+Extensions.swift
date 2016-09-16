//
//  UIView+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit

public extension UIView {
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set (newX) {
            frame = CGRect(origin: CGPoint(x: newX, y: y), size: frame.size)
        }
    }
    
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set (newY) {
            frame = CGRect(origin: CGPoint(x: x, y: newY), size: frame.size)
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set (newWidth) {
            frame = CGRect(origin: frame.origin, size: CGSize(width: newWidth, height: height))
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set (newHeight) {
            frame = CGRect(origin: frame.origin, size: CGSize(width: width, height: newHeight))
        }
    }
    
    public var bottomY: CGFloat {
        get {
            return CGRectGetMaxY(frame)
        }
    }
    
    public var rightX: CGFloat {
        get{
            return CGRectGetMaxX(frame)
        }
    }
    
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    public func optionalSnapshotViewAfterScreenUpdates(afterUpdates: Bool = false) -> UIView? {
        return snapshotViewAfterScreenUpdates(afterUpdates)
    }
}
