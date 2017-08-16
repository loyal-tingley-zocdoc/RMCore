//
//  HasReuseIdentifier.swift
//  RMCore
//
//  Created by Loyal Tingley on 8/16/17.
//  Copyright © 2017 Ryan Mannion. All rights reserved.
//

import Foundation
import UIKit

internal protocol HasReuseIdentifier {
    static var implicitReuseIdentifier: String { get }
}

extension UICollectionReusableView: HasReuseIdentifier {

    static var implicitReuseIdentifier: String {
        return "cellType->\(self)"
    }

}

extension UITableViewCell: HasReuseIdentifier {

    static var implicitReuseIdentifier: String {
        return "cellType->\(self)"
    }

}
