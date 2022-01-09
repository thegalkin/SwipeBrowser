//
//  PageManagerView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        ZStack {
            Color.black
            BottomBarView(isInTabsView: true)
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView ()
    }
}
