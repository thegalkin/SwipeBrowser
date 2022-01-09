//
//  PageManagerView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
import WebKit

struct TabsView: View {
    @EnvironmentObject var browserController: BrowserController
    var body: some View {
        ZStack {
            Color.black
            tabsOREmpty
            BottomBarView(isInTabsView: true)
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: self.settingsSheetIsPresented) {
            SettingsView ()
        }
    }
    private var settingsSheetIsPresented: Binding<Bool> {
        Binding<Bool>.init {
            self.browserController.isShowingSettingsSheet
        } set: { (newVal: Bool) in
            self.browserController.isShowingSettingsSheet = newVal
        }

    }
    
    @ViewBuilder
    private var tabsOREmpty: some View {
        if self.browserController.tabsList.isEmpty {
            emptyView
        } else {
            allTabsView
        }
    }
    
    private var emptyView: some View {
        Text("No tabs yet, add one?")
            .foregroundColor(Color.white)
    }
    private var allTabsView: some View {
        LazyVGrid(columns:
                    [GridItem.init(GridItem.Size.fixed(CGFloat(30.0)),
                                   spacing: CGFloat(10.0),
                                   alignment: Alignment.center)],
                  alignment: HorizontalAlignment.center,
                  spacing: CGFloat(10.0)
        ){
            ForEach(self.browserController.tabsList, id:\.id) { (tab: Tab) in
                tabCell(tab: tab)
            }
        }
    }
    
    private func tabCell(tab: Tab) -> some View {
        VStack {
            if let tabImageData: Data = tab.snapShot, let uiImage: UIImage = UIImage(data: tabImageData){
                Image(uiImage: uiImage)
            } else {
                Rectangle()
                    .background(.ultraThickMaterial)
                    .overlay {
                        VStack {
                            if let wkWebViewDataSource: WKWebView? = tab.webView as? WKWebView?,
                               let wkWebView: WKWebView = wkWebViewDataSource,
                               let url: URL = wkWebView.url,
                               let host: String = url.host
                            {
                                Text(wkWebView.title ?? String(host.prefix(1)))
                            } else {
                                Text("🧐")
                            }
                        }
                    }
            }
        }.cornerRadius(CGFloat(10.0))
        
        
            
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView ()
    }
}
