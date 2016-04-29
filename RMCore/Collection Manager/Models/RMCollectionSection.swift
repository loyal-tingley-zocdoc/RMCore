//
//  RMCollectionSection.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public class RMCollectionSection {
    public var rows: [RMCollectionRow] = []
    
    public init(rows: [RMCollectionRow] = []) {
        self.rows = rows
    }
}