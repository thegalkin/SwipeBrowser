//
//  URL.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 12.07.2022.
//

import Foundation

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
}


