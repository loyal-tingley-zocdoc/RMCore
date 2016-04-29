//
//  RMCollectionManager.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public class RMCollectionManager : NSObject {
    public var sections = [RMCollectionSection]()
    public weak var collectionView: UICollectionView? {
        didSet {
            if let collectionView = collectionView {
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.backgroundColor = UIColor.clearColor()
            }
        }
    }

    public override init() {
        super.init()
    }
    
    public func rowForIndexPath(indexPath: NSIndexPath) -> RMCollectionRow? {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        return row
    }
}

extension RMCollectionManager : UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section];
        return section.rows.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let row = rowForIndexPath(indexPath)!
        let identifier = row.cellIdentifier()
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? RMCollectionViewCell
        if (cell == nil) {
            let cellClass = row.cellClass as! RMCollectionViewCell.Type
            cell = cellClass.init(frame: CGRectZero)
        }
        
        row.indexPath = indexPath
        cell!.collectionRow = row
        
        return cell!
    }
}

extension RMCollectionManager : UICollectionViewDelegate {    
}
