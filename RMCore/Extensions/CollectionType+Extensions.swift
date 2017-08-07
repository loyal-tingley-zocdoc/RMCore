//
//  CollectionType+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 1/25/17.
//  Copyright © 2017 Ryan Mannion. All rights reserved.
//

import Foundation

public class RMGroup<ObjectType, GroupObjectType> {
    public let groupObject: GroupObjectType
    public let name: String?
    public var objects: [ObjectType]
    
    public init(groupObject: GroupObjectType, name: String?) {
        self.groupObject = groupObject
        self.name = name
        self.objects = [ObjectType]()
    }
}

public extension Collection {
    public func toDictionary<KeyType, ValueType> (transform:(_ element: Self.Iterator.Element) -> (key: KeyType, value: ValueType)?) -> [KeyType : ValueType] {
        var dictionary = [KeyType : ValueType]()
        for element in self {
            if let (key, value) = transform(element) {
                dictionary[key] = value
            }
        }
        return dictionary
    }
    
    public func toGroups<GroupObjectType> (
        groupObjectExtractor: (Generator.Element) -> GroupObjectType,
        groupObjectKeyExtractor: (GroupObjectType) -> String?,
        groupObjectNameExtractor: ((GroupObjectType) -> String?)? = nil)
        -> [RMGroup<Generator.Element, GroupObjectType>]
    {
        var groupsByGroupObjectKey = [String : RMGroup<Generator.Element, GroupObjectType>]()

        for object in self {
            let groupObject = groupObjectExtractor(object)

            let groupObjectKey = groupObjectKeyExtractor(groupObject) ?? ""

            let group = groupsByGroupObjectKey.findOrCreate(at: groupObjectKey) {
                let groupObjectName = groupObjectNameExtractor?(groupObject)
                return RMGroup<Generator.Element, GroupObjectType>(groupObject: groupObject, name: groupObjectName ?? groupObjectKey)
            }
            group.objects.append(object)
        }
        
        return Array(groupsByGroupObjectKey.values)
    }
    
    public var soleItem: Iterator.Element? {
        if count == 1 {
            return first
        }
        return nil
    }
}

public extension Collection where Indices.Iterator.Element == Index {
    public subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
