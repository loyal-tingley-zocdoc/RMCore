//
//  RMTableRow.swift
//  RMUtils
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit

class RMTableRow {
    var cellClass: AnyClass
    var userInfo: Any?
    var delegate: AnyObject?
    var isSelected = Observable(false)
    var isLastRow = false
    var indexPath: NSIndexPath?
    var height: CGFloat?
    
    init(withClass cellClass: AnyClass = RMTableViewCell.self, userInfo: Any? = nil, delegate: AnyObject? = nil) {
        self.cellClass = cellClass
        self.userInfo = userInfo
        self.delegate = delegate
    }
    
    func cellIdentifier() -> String {
        return "cellType->\(cellClass)"
    }
}
