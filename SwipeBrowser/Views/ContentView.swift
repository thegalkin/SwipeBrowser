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
    var body: some View {
        ZStack {
            PageView ()
//            NewPageView ()
        }
        .environmentObject(browserController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
