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
        let fromIndex: Index = index (from: from)
        return String (self[fromIndex...])
    }

    func substring (to: Int) -> String {
        let toIndex: Index = index (from: to)
        return String (self[..<toIndex])
    }

    func substring (with r: Range<Int>) -> String {
        let startIndex: Index = index (from: r.lowerBound)
        let endIndex: Index = index (from: r.upperBound)
        return String (self[startIndex ..< endIndex])
    }
    
    // Swift 5
    var isURL: Bool {
        if let url: NSURL = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        } else {
            return false
        }
    }

    static var empty: String {
        String("")
    }
}
