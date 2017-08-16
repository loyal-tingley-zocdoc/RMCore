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
    public var headerClass: RMCollectionSectionView.Type?
    public var headerHeight: CGFloat = 0
    public var userInfo: Any?
    
    public init(rows: [RMCollectionRow] = []) {
        self.rows = rows
    }
}
