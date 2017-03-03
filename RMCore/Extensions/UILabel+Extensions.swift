//
//  UILabel+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 5/10/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public extension UILabel {
    public convenience init(font: UIFont, textColor: UIColor) {
        self.init(frame: .zero)
        
        self.font = font
        self.textColor = textColor
    }
    
    public func enableMultiline() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
}
