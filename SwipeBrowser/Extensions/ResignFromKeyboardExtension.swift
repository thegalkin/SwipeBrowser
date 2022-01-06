//
//  ResignFromKeyboardExtension.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 07.01.2022.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
