//
//  RMTableSection.swift
//  RMUtils
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

class RMTableSection {
    var rows: [RMTableRow] = []
    
    init(rows: [RMTableRow] = []) {
        self.rows = rows
    }
}