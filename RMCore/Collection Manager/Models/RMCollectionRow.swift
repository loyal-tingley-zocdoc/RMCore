//
//  RMCollectionRow.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation
import Bond

public class RMCollectionRow {
    public var cellClass: AnyClass
    public var userInfo: Any?
    public var delegate: AnyObject?
    public var isSelected = Observable(false)
    public var isLastRow = false
    public var indexPath: NSIndexPath?
    public var height: CGFloat?
    
    public init(withClass cellClass: AnyClass = RMTableViewCell.self, userInfo: Any? = nil, delegate: AnyObject? = nil) {
        self.cellClass = cellClass
        self.userInfo = userInfo
        self.delegate = delegate
    }
    
    public func cellIdentifier() -> String {
        return "cellType->\(cellClass)"
    }
}