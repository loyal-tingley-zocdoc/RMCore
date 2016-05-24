//
//  RMTableViewCell.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit
import Bond

public class RMTableViewCell : UITableViewCell {
    public var tableRow: RMTableRow!
    internal var observers = [DisposableType]()
    
    required override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func flushObservers() {
        observers.forEach { $0.dispose() }
        observers.removeAll()
    }
    
    internal func observe<T>(observable: Observable<T>, observe: T -> Void) {
        let observer = observable.observe { (value) in
            observe(value)
        }
        observers.append(observer)
    }
}