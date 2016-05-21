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
    
    public var decimalString: String {
        let components = componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return components.joinWithSeparator("")
    }
    
    public var phoneNumberFormat: String {
        let decimalString = self.decimalString
        
        let length = decimalString.characters.count
        
        let hasLeadingOne = length > 0 && decimalString[decimalString.startIndex] == "1"
        
        if length == 0 || (length > 10 && hasLeadingOne == false) || length > 11 {
            return decimalString
        }
        
        var index = 0
        
        var formattedString = ""
        
        if hasLeadingOne {
            formattedString += "1 "
            index += 1
        }
        
        if length - index > 3 {
            let range = decimalString.startIndex.advancedBy(index)..<decimalString.startIndex.advancedBy(index + 3)
            let areaCode = decimalString[range]
            formattedString += "(" + areaCode + ") "
            index += 3
        }
        
        if length - index > 3 {
            let range = decimalString.startIndex.advancedBy(index)..<decimalString.startIndex.advancedBy(index + 3)
            let prefix = decimalString[range]
            formattedString += prefix + "-"
            index += 3
        }
        
        let range = decimalString.startIndex.advancedBy(index)..<decimalString.endIndex
        let remainder = decimalString[range]
        formattedString += remainder
        
        return formattedString
    }
}