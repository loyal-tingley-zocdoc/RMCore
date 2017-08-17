//
//  Dictionary+Extensions.swift
//  Pods
//
//  Created by Loyal Tingley on 8/7/17.
//
//

import Foundation

extension Dictionary {

    mutating func findOrCreate(at key: Key, create: (Key) -> Value) -> Value {
        switch self[key] {

        case let value?:
            return value

        case nil:
            let value = create(key)
            self[key] = value
            return value

        }
    }

    mutating func findOrCreate(at key: Key, create: () -> Value) -> Value {
        return findOrCreate(at: key) { (_: Key) in return create() }
    }

}
