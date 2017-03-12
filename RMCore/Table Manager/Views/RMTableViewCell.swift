//
//  RMTableViewCell.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

open class RMTableViewCell : UITableViewCell {
    open var tableRow: RMTableRow?
    internal var observers = [Disposable]()
    
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
        let observer = observable.observeNext { (value) in
            observe(value)
        }
        observers.append(observer)
    }
    
    public func observeNew<T>(observable: Observable<T>, observe: @escaping (T) -> Void) {
        let observer = observable.skip(first: 1).observeNext(with: { (value) in
            observe(value)
        })
        observers.append(observer)
    }
}
