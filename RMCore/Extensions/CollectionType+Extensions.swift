//
//  CollectionType+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 1/25/17.
//  Copyright © 2017 Ryan Mannion. All rights reserved.
//

import Foundation

public class RMGroup<ObjectType, GroupObjectType> {
    public let groupObject: GroupObjectType?
    public let name: String?
    public var objects: [ObjectType]
    
    public init(groupObject: GroupObjectType?, name: String?) {
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
        groupObjectNameExtractor: ((GroupObjectType) -> String?)? = nil) -> [RMGroup<Generator.Element, GroupObjectType>] where GroupObjectType: Any {
        var groupsByGroupObjectKey = [String : RMGroup<Generator.Element, GroupObjectType>]()
        var groups = [RMGroup<Generator.Element, GroupObjectType>]()
        for object in self {
            let groupObject = groupObjectExtractor(object)
            let groupObjectKey = groupObjectKeyExtractor(groupObject) ?? ""
            var group = groupsByGroupObjectKey[groupObjectKey]
            if group == nil {
                let groupObjectName = groupObjectNameExtractor?(groupObject)
                group = RMGroup<Generator.Element, GroupObjectType>(groupObject: groupObject, name: groupObjectName ?? groupObjectKey)
                groupsByGroupObjectKey[groupObjectKey] = group
                if let group = group {
                    groups.append(group)
                }
            }
            group?.objects.append(object)
        }
        
        return groups
    }
}

public extension Collection where Indices.Iterator.Element == Index {
    public subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
