//
//  HashableType.swift
//  RMCore
//
//  Created by Loyal Tingley on 8/16/17.
//  Copyright © 2017 Ryan Mannion. All rights reserved.
//

import Foundation

internal struct HashableType<Wrapped: AnyObject>: Hashable {
    internal var wrapped: Wrapped.Type

    internal init(_ wrapped: Wrapped.Type) {
        self.wrapped = wrapped
    }

    // MARK: - Equatable

    internal static func ==(l: HashableType, r: HashableType) -> Bool {
        return l.wrapped == r.wrapped
    }

    // MARK: - Hashable

    internal var hashValue: Int {
        return String(describing: wrapped).hashValue
    }
}
