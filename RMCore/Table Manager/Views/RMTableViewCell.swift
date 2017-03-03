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
        
        selectionStyle = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func flushObservers() {
        observers.forEach { $0.dispose() }
        observers.removeAll()
    }
    
    public func observe<T>(observable: Observable<T>, observe: @escaping (T) -> Void) {
        let observer = observable.observe { (value) in
            observe(value)
        }
        observers.append(observer)
    }
    
    public func observeNew<T>(observable: Observable<T>, observe: @escaping (T) -> Void) {
        let observer = observable.observeNew { (value) in
            observe(value)
        }
        observers.append(observer)
    }
}
