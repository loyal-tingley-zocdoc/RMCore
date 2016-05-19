//
//  RMTableSectionView.swift
//  RMCore
//
//  Created by Ryan Mannion on 5/18/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit

public class RMTableSectionView : UIView {
    var tableSection: RMTableSection
    
    required public init(tableSection: RMTableSection) {
        self.tableSection = tableSection
        
        super.init(frame: CGRectZero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
