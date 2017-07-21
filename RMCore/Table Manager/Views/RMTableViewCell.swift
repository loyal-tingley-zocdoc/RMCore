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

    public func observe<T: SignalProtocol>(observable: T, observe: @escaping (T.Element) -> Void) {
        let observer = observable.observeNext { (value) in
            observe(value)
        }
        observers.append(observer)
    }

    public func observeNew<T: SignalProtocol>(observable: T, observe: @escaping (T.Element) -> Void) {
        self.observe(observable: observable.skip(first: 1), observe: observe)
    }
}

open class RMTypedTableViewCell<UserInfo> : RMTableViewCell {
    open var userInfo: UserInfo?

    open override var tableRow: RMTableRow? {
        didSet {
            userInfo = tableRow?.userInfo as? UserInfo
        }
    }
}
