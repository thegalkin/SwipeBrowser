//
//  SafeAreaSizes.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 12.07.2022.
//

import SwiftUI

extension SafeAreaRegions {
    static var window: UIWindow? {
        UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
    static var top: CGFloat? {
        if let window {
            return window.safeAreaInsets.top
        } else {
            return nil
        }
    }
    
    static var bottom: CGFloat? {
        if let window {
            return window.safeAreaInsets.bottom
        } else {
            return nil
        }
    }
    
    static var left: CGFloat? {
        if let window {
            return window.safeAreaInsets.left
        } else {
            return nil
        }
    }
    
    static var right: CGFloat? {
        if let window {
            return window.safeAreaInsets.right
        } else {
            return nil
        }
    }

    static var topOrZero: CGFloat {
        return top ?? 0
    }

    static var bottomOrZero: CGFloat {
        return bottom ?? 0
    }

    static var leftOrZero: CGFloat {
        return left ?? 0
    }

    static var rightOrZero: CGFloat {
        return right ?? 0
    }

    static var topRectangle: CGRect? {
        if let window {
            return CGRect(x: 0, y: 0, width: window.frame.width, height: window.safeAreaInsets.top)
        } else {
            return nil
        }
    }

    static var bottomRectangle: CGRect? {
        if let window {
            return CGRect(x: 0, y: window.frame.height - window.safeAreaInsets.bottom, width: window.frame.width, height: window.safeAreaInsets.bottom)
        } else {
            return nil
        }
    }

    static var leftRectangle: CGRect? {
        if let window {
            return CGRect(x: 0, y: 0, width: window.safeAreaInsets.left, height: window.frame.height)
        } else {
            return nil
        }
    }

    static var rightRectangle: CGRect? {
        if let window {
            return CGRect(x: window.frame.width - window.safeAreaInsets.right, y: 0, width: window.safeAreaInsets.right, height: window.frame.height)
        } else {
            return nil
        }
    }
}
