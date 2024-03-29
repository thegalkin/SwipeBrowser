//
//  ContentView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI

/** Здесь хранится новая страница или текущая страница или менеджер вкладок*/
struct ContentView: View {
    @StateObject var browserController: BrowserController = .init()
    @StateObject var pageViewModel: PageViewModel = .init()
    
    @State var isShowingPage: Bool = false
    @State private var offset: CGFloat = 200

    var body: some View {
        Group{
            if self.browserController.isShowingTabsView {
                tabsView.transition(.slide)
            } else {
                pageView.transition(.slide)
            }
        }
        .environmentObject(browserController)
        .environmentObject(pageViewModel)
    }
    
    private var pageView: some View {
        VStack{
            //FIXME: транзишн insertion и removal кажется путаются, надо их распутать. view улетает непойми куда
            PageView (open: self.$browserController.currentTabURL)
                .transition(.asymmetric(insertion: AnyTransition.windmillRotationEnter, removal: AnyTransition.windmillRotationExit))
//                .id(self.browserController.currentTabViewID)
                .onAppear {
                    if self.browserController.currentTabURL == nil {
                        self.browserController.currentTabURL = URL(string: "https://shazoo.ru")!
                    }
                }
        }
    }
    
    private var tabsView: some View {
        TabsView ()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
