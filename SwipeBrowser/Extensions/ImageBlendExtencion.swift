//
//  ImageBlendExtencion.swift
//  MyPrepod13
//
//  Created by Никита Галкин on 17.02.2021.
//

import SwiftUI

public struct ColorBlended: ViewModifier {
    fileprivate var color: Color

    public func body (content: Content) -> some View {
        VStack {
            ZStack {
                content
                color.blendMode (.sourceAtop)
            }
                    .drawingGroup (opaque: false)
        }
    }
}

extension View {
    public func blending (color: Color) -> some View {
        modifier (ColorBlended (color: color))
    }
}
