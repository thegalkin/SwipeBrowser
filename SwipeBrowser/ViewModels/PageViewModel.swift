//
//  PageViewModel.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
import Combine

final class PageViewModel: ObservableObject {
//    @Published var hasSetCurrentAddressBefore: Bool = false
    @Published var currentAddress: URL? = nil
    @Published var pageHistory: [URL]?
    
    @Published var bottomBar: BottomBar = .init ()
    @Published var isShowingTabsView: Bool = false
    /**computed; don't touch**/
    @Published var isShowingNewTabView: Bool = false
    
    public func setAddress(with url: URL?) {
//        if !hasSetCurrentAddressBefore {
            self.currentAddress = url
//            self.hasSetCurrentAddressBefore = true
//        }
    }
}


struct BottomBar {
    var color: Color = .accentColor
}
