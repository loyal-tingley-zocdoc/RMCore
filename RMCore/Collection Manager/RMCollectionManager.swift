//
//  RMCollectionManager.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public protocol RMCollectionManagerDelegate {
    func collectionManager(collectionManager: RMCollectionManager, didSelectCollectionRow collectionRow: RMCollectionRow)
}

public class RMCollectionManager : NSObject {
    public var delegate: RMCollectionManagerDelegate?
    public var sections = [RMCollectionSection]()
    public weak var collectionView: UICollectionView? {
        didSet {
            if let collectionView = collectionView {
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.backgroundColor = UIColor.clear
            }
        }
    }
    public var layout: UICollectionViewLayout?
    
    public override init() {
        super.init()
    }
    
    public func rowForIndexPath(indexPath: IndexPath) -> RMCollectionRow? {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        return row
    }
    
    public func registerClasses() {
        let cellClasses = NSMutableSet()
        let headerClasses = NSMutableSet()
        
        for section in sections {
            for row in section.rows {
                cellClasses.add(row.cellClass)
            }
            if let headerClass = section.headerClass {
                headerClasses.add(headerClass)
            }
        }
        
        for obj in cellClasses {
            let cellClass: AnyClass = obj as! AnyClass
            collectionView?.register(cellClass, forCellWithReuseIdentifier: "cellType->\(cellClass)")
        }
        
        for obj in headerClasses {
            let headerClass: AnyClass = obj as! AnyClass
            collectionView?.register(headerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "cellType->\(headerClass)")
        }
    }
    
    public var allRows: [RMCollectionRow] {
        var rows = [RMCollectionRow]()
        
        for section in sections {
            rows += section.rows
        }
        
        return rows
    }
    
    public var selectedRows: [RMCollectionRow] {
        return allRows.filter {
            $0.isSelected.value
        }
    }
    
    public func unselectSelectedRows() {
        selectedRows.forEach {
            $0.isSelected.value = false
        }
    }
}

extension RMCollectionManager : UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section];
        return section.rows.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = rowForIndexPath(indexPath: indexPath)!
        let identifier = row.cellIdentifier()
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? RMCollectionViewCell
        if (cell == nil) {
            let cellClass = row.cellClass
            cell = cellClass.init(frame: .zero)
        }
        
        row.indexPath = indexPath
        cell!.collectionRow = row
        
        return cell!
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView?
        
        if kind == UICollectionElementKindSectionHeader {
            let section = sections[indexPath.section]
            if section.headerClass != nil {
                let headerClass = section.headerClass as! RMCollectionSectionView.Type
                let reuseIdentifier = "cellType->\(headerClass)"
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! RMCollectionSectionView
                headerView.collectionSection = section
                reusableView = headerView
            }
        }
        
        return reusableView!
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = sections[section]
        var size: CGSize = .zero
        
        if section.headerHeight > 0 {
            size = CGSize(width: collectionView.width, height: section.headerHeight)
        }
        
        return size
    }
}

extension RMCollectionManager : UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let collectionRow = rowForIndexPath(indexPath: indexPath) {
            delegate?.collectionManager(collectionManager: self, didSelectCollectionRow: collectionRow)
        }
    }
}
