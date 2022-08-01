//
//  URL.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 12.07.2022.
//

import Foundation
import UIKit

public extension URL {
    func deletingLastPathSlash () -> URL {
        let absoluteString: String = self.absoluteString
        if absoluteString.last == "/" {
            let cutString: String = String(absoluteString.dropLast())
            guard cutString.isURL else { return self }
            return URL(string: cutString)!
        } else {
            return self
        }
    }
    
    var isValid: Bool {
        let urlRegEx = String("^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$")
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self.absoluteString)
        return result
    }
    
}

extension URL {
    var rootDomain: String? {
//        guard let hostName = self.host else { return nil }
        let components = self.absoluteString.components(separatedBy: ".")
        
        if components.count == 2 {
            return components[0]
        }
        
        if components.count > 2 {
            return components.suffix(2).joined(separator: ".")
        } else {
            return self.absoluteString
        }
    }
}
