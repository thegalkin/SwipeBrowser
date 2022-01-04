//
//  PageViewModel.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
import Combine

final class PageViewModel: ObservableObject {
    @Published var currentAddress: URL? = URL(string: "https://shazoo.ru")!
    @Published var pageHistory: [URL]?
    
    @Published var bottomBar: BottomBar = .init ()
    @Published var isShowingTabsView: Bool = false
}


struct BottomBar {
    var color: Color = .accentColor
}
