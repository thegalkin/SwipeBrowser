//
//  TextModifierExtension.swift
//  MyPrepod13
//
//  Created by Никита Галкин on 15.04.2021.
//

import SwiftUI

protocol TextModifier {
    associatedtype Body: View

    func body (text: Text) -> Body
}

extension Text {
    func modifier<TM: TextModifier> (_ theModifier: TM) -> some View {
        return theModifier.body (text: self)
    }
}
