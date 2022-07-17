//
//  StringExtencion.swift
//  MyPrepod13
//
//  Created by Никита Галкин on 14.01.2021.
//

import Foundation
import UIKit

extension String {
    func index (from: Int) -> Index {
        return self.index (startIndex, offsetBy: from)
    }

    func substring (from: Int) -> String {
        let fromIndex = index (from: from)
        return String (self[fromIndex...])
    }

    func substring (to: Int) -> String {
        let toIndex = index (from: to)
        return String (self[..<toIndex])
    }

    func substring (with r: Range<Int>) -> String {
        let startIndex = index (from: r.lowerBound)
        let endIndex = index (from: r.upperBound)
        return String (self[startIndex ..< endIndex])
    }
    
    // Swift 5
    var isURL: Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        } else {
            return false
        }
    }
}
