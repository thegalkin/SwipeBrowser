//
//  safeSpaceExtencion.swift
//  MyPrepod13
//
//  Created by Никита Галкин on 12.02.2021.
//

import Foundation
import SwiftUI

extension UIDevice {
    /// Returns `true` if the device has a notch
    /// need for toolbar
    var hasNotch: Bool {
        guard #available (iOS 11.0, *),
              let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else {
            return false
        }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
