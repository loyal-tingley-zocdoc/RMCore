//
//  String+Extensions.swift
//  RMCore
//
//  Created by Ryan Mannion on 4/29/16.
//  Copyright © 2016 Ryan Mannion. All rights reserved.
//

import Foundation

public extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    public func urlEncoded() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
    public func stringByAppendingQueryParameters(queryParameters: [String: AnyObject]) -> String {
        let keyValuePairs = queryParameters.map { (key, value) -> String in
            return "\(key.urlEncoded())=\(value.description.urlEncoded())"
        }
        
        let prefix = containsString("?") ? "&" : "?"
        
        return self + prefix + keyValuePairs.joinWithSeparator("&")
    }
}