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
    func tableManager(tableManager: RMTableManager, didMoveTableRow tableRow: RMTableRow, fromIndexPath sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath)
}

public class RMTableManager : NSObject {
    public var delegate: RMTableManagerDelegate?
    
    public var sections = [RMTableSection]() {
        didSet {
            refreshIndexPaths()
        }
    }
    
    public var sectionIndexOffset = 0

    public weak var tableView: UITableView? {
        didSet {
            if let tableView = tableView {
                tableView.dataSource = self
                tableView.delegate = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 48
                tableView.rowHeight = UITableViewAutomaticDimension
                tableView.backgroundColor = UIColor.clear
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
                tableRow.indexPath = IndexPath(row: row, section: section)
                tableRow.isLastRow = false
                row += 1
            }
            tableSection.rows.last?.isLastRow = true
            section += 1
        }
    }
    
    public func row(for indexPath: IndexPath) -> RMTableRow? {
        let tableSection = sections[indexPath.section]
        let tableRow = tableSection.rows[indexPath.row]
        return tableRow
    }
    
    public func insertRow(row: RMTableRow, atIndexPath indexPath: IndexPath = IndexPath(row: 0, section: 0)) {
        let section = sections[indexPath.section]
        section.rows.insert(row, at: indexPath.row)
        
        tableView?.beginUpdates()
        tableView?.insertRows(at: [indexPath], with: .automatic)
        tableView?.endUpdates()
        
        refreshIndexPaths()
    }
    
    public func deleteRows(rows: [RMTableRow]) {
        var indexPaths = [IndexPath]()
        
        for tableRow in rows {
            if let indexPath = tableRow.indexPath {
                let tableSection = sections[indexPath.section]
                if let index = tableSection.rows.index(where: { (aTableRow) -> Bool in
                    aTableRow === tableRow
                }) {
                    indexPaths.append(indexPath)
                    tableSection.rows.remove(at: index)
                }
            }
        }
        
        if let aTableView = tableView {
            aTableView.beginUpdates()
            aTableView.deleteRows(at: indexPaths, with: .automatic)
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
    
    public func allIndexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
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
            aTableView.deleteRows(at: allIndexPaths, with: .automatic)
            aTableView.endUpdates()
        }
    }
}

extension RMTableManager : UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSection = sections[safe: section] else {
            return 0
        }
        
        return tableSection.closed.value ? 0 : tableSection.rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableRow = row(for: indexPath)!
        let identifier = tableRow.cellIdentifier()
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RMTableViewCell
        if (cell == nil) {
            let tableCellClass = tableRow.cellClass as! RMTableViewCell.Type
            cell = tableCellClass.init(style: .default, reuseIdentifier: identifier)
        }
        
        tableRow.indexPath = indexPath
        cell!.tableRow = tableRow
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableSection = sections[section]
        return tableSection.headerText
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let tableSection = sections[section]
        return tableSection.headerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView?
        
        let tableSection = sections[section]
        
        if let headerClass = tableSection.headerClass as? RMTableSectionView.Type {
            headerView = headerClass.init(tableSection: tableSection, delegate: tableSection.headerDelegate)
        }
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let tableSection = sections[safe: section] else {
            return 0
        }
        
        return tableSection.footerHeight
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView: UIView?
        
        let tableSection = sections[section]
        
        if let footerClass = tableSection.footerClass as? RMTableSectionView.Type {
            footerView = footerClass.init(tableSection: tableSection, delegate: tableSection.headerDelegate)
        }
        
        return footerView
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var canEdit = false
        
        if let tableRow = row(for: indexPath) {
            canEdit = tableRow.editable || tableRow.deletable
        }
        
        return canEdit
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        var canMove = false
        
        if let tableRow = row(for: indexPath) {
            canMove = tableRow.editable
        }
        
        return canMove
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let tableRow = row(for: indexPath) {
            let tableSection = sections[indexPath.section]
            
            if delegate?.tableManager(tableManager: self, shouldDeleteTableRow: tableRow) ?? false {
                tableSection.rows.remove(at: indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
                delegate?.tableManager(tableManager: self, didDeleteTableRow: tableRow)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let tableRow = row(for: sourceIndexPath) {
            let sourceTableSection = sections[sourceIndexPath.section]
            sourceTableSection.rows.remove(at: sourceIndexPath.row)
            
            let destinationTableSection = sections[destinationIndexPath.section]
            destinationTableSection.rows.insert(tableRow, at: destinationIndexPath.row)
            
            delegate?.tableManager(tableManager: self, didMoveTableRow: tableRow, fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
        }
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let indexTitles = sections.reduce([String]()) {
            if let indexTitle = $1.indexTitle {
                return $0 + [indexTitle]
            } else {
                return $0
            }
        }
        return indexTitles
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index + sectionIndexOffset
    }
}

extension RMTableManager : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableRow = row(for: indexPath) {
            delegate?.tableManager(tableManager: self, didSelectTableRow: tableRow)
        }
    }
}
