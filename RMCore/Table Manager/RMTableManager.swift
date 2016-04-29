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
}

public class RMTableManager : NSObject {
    public var delegate: RMTableManagerDelegate?
    
    public var sections = [RMTableSection]()
    public weak var tableView: UITableView? {
        didSet {
            if let tableView = tableView {
                tableView.dataSource = self
                tableView.delegate = self
                tableView.separatorStyle = .None
                tableView.estimatedRowHeight = 48
                tableView.rowHeight = UITableViewAutomaticDimension
                tableView.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    public override init() {
        super.init()
    }
    
    public func refreshIndexPaths() {
        var section = 0
        for tableSection in sections {
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
        return tableSection.rows.count
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
}

extension RMTableManager : UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let tableRow = rowForIndexPath(indexPath) {
            delegate?.tableManager(self, didSelectTableRow: tableRow)
        }
    }
}
