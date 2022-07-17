//
//  IsNil.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 13.07.2022.
//

import Foundation

extension Optional {
    public var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}
