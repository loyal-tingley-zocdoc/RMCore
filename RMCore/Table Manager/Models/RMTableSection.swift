//
//  RMTableSection.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public class RMTableSection {
    public var rows: [RMTableRow] = []
    
    public init(rows: [RMTableRow] = []) {
        self.rows = rows
    }
}