//
//  PageViewModel.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
import Combine
import WebKit

final class PageViewModel: ObservableObject {
//    @Published var hasSetCurrentAddressBefore: Bool = false
    @Published var currentAddress: URL? = nil
    @Published var currentWebView: UIView? = nil
    @Published var pageHistory: [URL]?
    
    @Published var bottomBar: BottomBar = .init ()
    @Published var isShowingTabsView: Bool = false
    /**computed; don't touch**/
    @Published var isShowingNewTabView: Bool = false
    
    @Published var topAndBottomSafeAreaCalayerScans: VerticalLayerScan = .init()
    @Published var topAndBottomSafeAreaScanningTimer: Timer? = nil 
    
    public func setAddress(with url: URL?) {
//        if !hasSetCurrentAddressBefore {
            self.currentAddress = url
//            self.hasSetCurrentAddressBefore = true
        setUpLoadingProgressPublisher()
//        }
    }
    
    var cancellables: Set<AnyCancellable> = .init()
    private func setUpLoadingProgressPublisher () {
        guard let webView: WKWebView = currentWebView as? WKWebView else { return }
        webView
            .publisher(for: \.estimatedProgress, options: [.new])
            .assign(to: \.bottomBar.loadingProgress, on: self)
            .store(in: &cancellables)
    }
}

struct BottomBar {
    var color: Color = .accentColor
    var loadingProgress: Double = 0
}
