//
//  RMTableSection.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation
import Bond

public class RMTableSection {
    public var rows: [RMTableRow] = []
    public var headerClass: AnyClass?
    public var headerDelegate: RMTableSectionViewDelegate?
    public var userInfo: Any?
    public var closed: Observable<Bool> = Observable(false)
    public var section: Int = 0
    
    public init(rows: [RMTableRow] = []) {
        self.rows = rows
    }
    
    public var selectedRows: [RMTableRow] {
        return rows.filter { $0.isSelected.value }
    }
}