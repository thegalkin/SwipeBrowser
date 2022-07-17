//
//  View.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 08.01.2022.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func getUIView () -> UIView {
        let uiView: UIView = UIHostingController.init(rootView: self.body).view
        return uiView
    }
}
