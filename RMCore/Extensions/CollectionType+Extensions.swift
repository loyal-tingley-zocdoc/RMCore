//
//  CollectionType+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 1/25/17.
//  Copyright © 2017 Ryan Mannion. All rights reserved.
//

import Foundation

public class RMGroup<ObjectType> {
    public let groupObject: Any?
    public let name: String?
    public var objects: [ObjectType]
    
    public init(groupObject: Any?, name: String?) {
        self.groupObject = groupObject
        self.name = name
        self.objects = [ObjectType]()
    }
}

public extension CollectionType {
    public func toDictionary<KeyType, ValueType> (transform:(element: Self.Generator.Element) -> (key: KeyType, value: ValueType)?) -> [KeyType : ValueType] {
        var dictionary = [KeyType : ValueType]()
        for element in self {
            if let (key, value) = transform(element: element) {
                dictionary[key] = value
            }
        }
        return dictionary
    }
    
    public func toGroups<GroupObjectType where GroupObjectType: Any>(
        groupObjectExtractor groupObjectExtractor: Generator.Element -> GroupObjectType,
                             groupObjectKeyExtractor: GroupObjectType -> String?,
                             groupObjectNameExtractor: (GroupObjectType -> String?)? = nil) -> [RMGroup<Generator.Element>] {
        var groupsByGroupObjectKey = [String : RMGroup<Generator.Element>]()
        var groups = [RMGroup<Generator.Element>]()
        for object in self {
            let groupObject = groupObjectExtractor(object)
            let groupObjectKey = groupObjectKeyExtractor(groupObject) ?? ""
            var group = groupsByGroupObjectKey[groupObjectKey]
            if group == nil {
                let groupObjectName = groupObjectNameExtractor?(groupObject)
                group = RMGroup<Generator.Element>(groupObject: groupObject, name: groupObjectName ?? groupObjectKey)
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
