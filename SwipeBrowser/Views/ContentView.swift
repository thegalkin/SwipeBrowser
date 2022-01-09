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
    
    @State var isShowingPage: Bool = false
    @State private var offset: CGFloat = 200

    var body: some View {
        VStack{
            //FIXME: транзишн insertion и removal кажется путаются, надо их распутать. view улетает непойми куда
            PageView (open: self.browserController.currentTabURL)                
                .transition(.asymmetric(insertion: AnyTransition.windmillRotationEnter, removal: AnyTransition.windmillRotationExit))
                .id(self.browserController.currentTabViewID)
                .environmentObject(browserController)
            
                .onAppear {
                    self.browserController.currentTabURL = URL(string: "https://beta.shazoo.ru")!
                }
                
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
