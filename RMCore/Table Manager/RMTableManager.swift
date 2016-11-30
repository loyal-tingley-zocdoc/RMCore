//
//  RMTableManager.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public protocol RMTableManagerDelegate {
    func tableManager(tableManager: RMTableManager, didSelectTableRow tableRow: RMTableRow)
    func tableManager(tableManager: RMTableManager, shouldDeleteTableRow tableRow: RMTableRow) -> Bool
    func tableManager(tableManager: RMTableManager, didDeleteTableRow tableRow: RMTableRow)
    func tableManager(tableManager: RMTableManager, didMoveTableRow tableRow: RMTableRow, fromIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
}

public class RMTableManager : NSObject {
    public var delegate: RMTableManagerDelegate?
    
    public var sections = [RMTableSection]() {
        didSet {
            refreshIndexPaths()
        }
    }
    
    public weak var tableView: UITableView? {
        didSet {
            if let tableView = tableView {
                tableView.dataSource = self
                tableView.delegate = self
                tableView.separatorStyle = .None
                tableView.estimatedRowHeight = 48
                tableView.rowHeight = UITableViewAutomaticDimension
                tableView.backgroundColor = UIColor.clearColor()
                tableView.estimatedSectionHeaderHeight = 0
                tableView.sectionHeaderHeight = UITableViewAutomaticDimension
            }
        }
    }
    
    public override init() {
        super.init()
    }
    
    public func refreshIndexPaths() {
        var section = 0
        for tableSection in sections {
            tableSection.section = section
            
            var row = 0
            for tableRow in tableSection.rows {
                tableRow.indexPath = NSIndexPath(forRow: row, inSection: section)
                tableRow.isLastRow = false
                row += 1
            }
            tableSection.rows.last?.isLastRow = true
            section += 1
        }
    }
    
    public func rowForIndexPath(indexPath: NSIndexPath) -> RMTableRow? {
        let tableSection = sections[indexPath.section]
        let tableRow = tableSection.rows[indexPath.row]
        return tableRow
    }
    
    public func insertRow(row: RMTableRow, atIndexPath indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)) {
        let section = sections[indexPath.section]
        section.rows.insert(row, atIndex: indexPath.row)
        
        tableView?.beginUpdates()
        tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView?.endUpdates()
        
        refreshIndexPaths()
    }
    
    public func deleteRows(rows: [RMTableRow]) {
        var indexPaths = [NSIndexPath]()
        
        for tableRow in rows {
            if let indexPath = tableRow.indexPath {
                let tableSection = sections[indexPath.section]
                if let index = tableSection.rows.indexOf({ (aTableRow) -> Bool in
                    aTableRow === tableRow
                }) {
                    indexPaths.append(indexPath)
                    tableSection.rows.removeAtIndex(index)
                }
            }
        }
        
        if let aTableView = tableView {
            aTableView.beginUpdates()
            aTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            aTableView.endUpdates()
        }
        
        refreshIndexPaths()
    }
    
    public func allRows() -> [RMTableRow] {
        var rows = [RMTableRow]()
        
        for tableSection in sections {
            rows += tableSection.rows
        }
        
        return rows
    }
    
    public func selectedRows() -> [RMTableRow] {
        return allRows().filter { (tableRow) -> Bool in
            return tableRow.isSelected.value
        }
    }
    
    public func unselectSelectedRows() {
        for row in selectedRows() {
            row.isSelected.value = false
        }
    }
    
    public func allIndexPaths() -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        
        for tableSection in sections {
            for tableRow in tableSection.rows {
                if let indexPath = tableRow.indexPath {
                    indexPaths.append(indexPath)
                }
            }
        }
        
        return indexPaths
    }
    
    public func deleteAllRows() {
        let allIndexPaths = self.allIndexPaths()
        sections = [RMTableSection()]
        
        if let aTableView = tableView {
            aTableView.beginUpdates()
            aTableView.deleteRowsAtIndexPaths(allIndexPaths, withRowAnimation: .Automatic)
            aTableView.endUpdates()
        }
    }
}

extension RMTableManager : UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = sections[section]
        return tableSection.closed.value ? 0 : tableSection.rows.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableRow = rowForIndexPath(indexPath)!
        let identifier = tableRow.cellIdentifier()
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? RMTableViewCell
        if (cell == nil) {
            let tableCellClass = tableRow.cellClass as! RMTableViewCell.Type
            cell = tableCellClass.init(style: .Default, reuseIdentifier: identifier)
        }
        
        tableRow.indexPath = indexPath
        cell!.tableRow = tableRow
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableSection = sections[section]
        return tableSection.headerText
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView?
        
        let tableSection = sections[section]
        
        if let headerClass = tableSection.headerClass as? RMTableSectionView.Type {
            headerView = headerClass.init(tableSection: tableSection, delegate: tableSection.headerDelegate)
        }
        
        return headerView
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var canEdit = false
        
        if let tableRow = rowForIndexPath(indexPath) {
            canEdit = tableRow.editable || tableRow.deletable
        }
        
        return canEdit
    }
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var canMove = false
        
        if let tableRow = rowForIndexPath(indexPath) {
            canMove = tableRow.editable
        }
        
        return canMove
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let tableRow = rowForIndexPath(indexPath) {
            let tableSection = sections[indexPath.section]
            
            if delegate?.tableManager(self, shouldDeleteTableRow: tableRow) ?? false {
                tableSection.rows.removeAtIndex(indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
                
                delegate?.tableManager(self, didDeleteTableRow: tableRow)
            }
        }
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if let tableRow = rowForIndexPath(sourceIndexPath) {
            let sourceTableSection = sections[sourceIndexPath.section]
            sourceTableSection.rows.removeAtIndex(sourceIndexPath.row)
            
            let destinationTableSection = sections[destinationIndexPath.section]
            destinationTableSection.rows.insert(tableRow, atIndex: destinationIndexPath.row)
            
            delegate?.tableManager(self, didMoveTableRow: tableRow, fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
        }
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        let indexTitles = sections.reduce([String]()) {
            if let indexTitle = $1.indexTitle {
                return $0 + [indexTitle]
            } else {
                return $0
            }
        }
        return indexTitles
    }
}

extension RMTableManager : UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let tableRow = rowForIndexPath(indexPath) {
            delegate?.tableManager(self, didSelectTableRow: tableRow)
        }
    }
}