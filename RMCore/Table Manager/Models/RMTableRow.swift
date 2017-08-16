//
//  RMTableRow.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit
import Bond

public class RMTableRow {
    public var cellClass: RMTableViewCell.Type
    public var userInfo: Any?
    public weak var delegate: AnyObject?
    public var isSelected = Observable(false)
    public var isLastRow = false
    public var indexPath: IndexPath?
    public var height: CGFloat?
    public var editable = false
    public var deletable = false
    public var editActions: [UITableViewRowAction]?

    public init(cellClass: RMTableViewCell.Type = RMTableViewCell.self, userInfo: Any? = nil, delegate: AnyObject? = nil) {
        self.cellClass = cellClass
        self.userInfo = userInfo
        self.delegate = delegate
    }
    
    public func cellIdentifier() -> String {
        return cellClass.implicitReuseIdentifier
    }
}
