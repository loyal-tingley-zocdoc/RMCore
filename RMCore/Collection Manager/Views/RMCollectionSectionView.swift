//
//  RMCollectionSectionView.swift
//  RMCore
//
//  Created by Ryan Mannion on 5/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public class RMCollectionSectionView : UICollectionReusableView {
    open var collectionSection: RMCollectionSection?

    public required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
