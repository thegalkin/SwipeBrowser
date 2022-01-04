//
//  SettingsViewModel.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
import Combine


enum AppSettings: String {
    
    case minSwipeOffset = "minSwipeOffset"
    case selectedColorScheme = "selectedColorScheme"
    case newPageOpensInNewTab = "newPageOpensInNewTab"
    
    
//    private func prefixed(_ string: String) -> String {
//        private let prefix = "AppSettings_"
//        return prefix.appending(contentsOf: string)
//    }
}

enum ColorScheme {
    case dark
    case light
    case system
}
//
//@propertyWrapper
//struct UserDefault<Value> {
//    let key: String
//    let defaultValue: Value
//
//
//    @available(*, unavailable)
//    var wrappedValue: Value {
//        get { fatalError("This wrapper only works on instance properties of classes") }
//        set { fatalError("This wrapper only works on instance properties of classes") }
//    }
//
//    static subscript(
//        _enclosingInstance instance: AppSettings,
//        wrapped wrappedKeyPath: ReferenceWritableKeyPath<AppSettings, Value>
//        ) -> Value {
//        get {
//
//            let key = String(describing: wrappedKeyPath)
//            let defaultValue = propertyWrapper.defaultValue
//            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
//        }
//        set {
//            let propertyWrapper = instance[keyPath: storageKeyPath]
//            let key = String(describing: wrappedKeyPath)
//            UserDefaults.standard.set(newValue, forKey: key)
//        }
//    }
//}
