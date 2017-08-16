//
//  RMTableSectionView.swift
//  RMCore
//
//  Created by Ryan Mannion on 5/18/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit

public protocol RMTableSectionViewDelegate: class {
    func tableSectionView(tableSectionView: RMTableSectionView, tappedWithTableSection tableSection: RMTableSection)
}

open class RMTableSectionView : UIView {
    public var tableSection: RMTableSection
    public weak var delegate: RMTableSectionViewDelegate?
    
    required public init(tableSection: RMTableSection, delegate: RMTableSectionViewDelegate? = nil) {
        self.tableSection = tableSection
        self.delegate = delegate
        
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
