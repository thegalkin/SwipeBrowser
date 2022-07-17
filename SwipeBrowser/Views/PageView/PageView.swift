//
//  PageView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI

/**
 Уровень свайпов для вкладки
 - Parameters:
 - open: Открывает ссылку в новой вкладке.
 
 */
struct PageView: View {
    
    let open: URL?
    
    @EnvironmentObject var pageViewModel: PageViewModel
    @EnvironmentObject var browserController: BrowserController
    
    @State var pageOffset: CGFloat = 0
    @State var minSwipeOffset: CGFloat = UIScreen.main.bounds.width / 2
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let pageDissapearTime: Double = 0.5
    let offset: CGFloat = 40
    
    var body: some View {
        ZStack(alignment: Alignment.center) {
                currentPageWithEffect
                newPageWithEffect
                bottomBar
            }
        .onReceive(self.browserController.$newTabOrderPromised) {
            if $0 {
                self.presentNewTab()
            }
        }
        .onChange(of: self.pageOffset) { (newVal: CGFloat) in
            if newVal == -self.screenWidth {
                self.pageViewModel.isShowingNewTabView = true
                self.browserController.newPageButtonIsOn = false
            } else {
                self.pageViewModel.isShowingNewTabView = false
                self.browserController.newPageButtonIsOn = true
            }
        }
        .onAppear {
            // странный способ инициализации, чтобы избежать бага с multiple appear
            if self.pageViewModel.currentAddress == nil {
                self.pageViewModel.setAddress(with: self.open)
            }
            if self.open == nil {
                self.pageOffset = self.screenWidth
            }
        }
    }
    
//    MARK: - Buttom Bar
    private var bottomBar: some View {
            BottomBarView (isInTabsView: false)
                .environmentObject(pageViewModel)
    }
    
//    MARK: - Current Page
    private var currentPage: some View {
        GeometryReader { (geo: GeometryProxy) in
            VStack {
                topSafeAreaScan
                WebContentView ()
                    .environmentObject(pageViewModel)
                    .frame(height: SafeAreaRegions.window?.frame.height ?? CGFloat.zero - SafeAreaRegions.topOrZero - SafeAreaRegions.bottomOrZero)
#if DEBUG
                    .border(.pink)
#endif
                bottomSafeAreaScan
            }
        }
    }

    private var currentPageWithEffect: some View {
        ZStack{
            currentPage
                .rotationEffect(self.currentPageRotationScale.wrappedValue)
                .scaleEffect(self.currentPageScaleScale.wrappedValue)
                .offset(x: pageOffset, y: currentPageYOffset.wrappedValue)
                .onAppear {
                    self.startTimer()
                }
                
//                .onDisappear{
//                    self.stopTimer()
//                }
            leftPanGestureRecogniserView
        }

    }
    
//    MARK: - New Page
    private var newPage: some View {
        GeometryReader { (geo: GeometryProxy) in
            NewPageView()
                .environmentObject(browserController)
        }
    }
    
    private var newPageWithEffect: some View {
        newPage
            .rotationEffect(self.newPageRotationScale.wrappedValue, anchor: .center)
            .scaleEffect(self.newPageScaleScale.wrappedValue)
//            .gesture(self.leftPanGesture)
            .offset(x: self.newPageXOffset.wrappedValue, y: self.newPageYOffset.wrappedValue)
    }
    
//    MARK: - Left Pan Recognizer
    private var leftPanGestureRecogniserView: some View {
        HStack {
            Spacer ()
                .frame(width: self.screenWidth - 20)
            Color.white
                .opacity(0.001)
                .gesture(self.leftPanGesture)
        }
        
        .frame(height: self.screenHeight - 50)
//        .offset(x: 0, y: -34)
        
    }

    
    private func presentNewTab () {
        withAnimation {
            self.browserController.isShowingTabsView = false
            self.pageOffset = -self.screenWidth
        }

        let milliseconds: Int = Int(self.pageDissapearTime) * 1000
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
            self.browserController.newTabOrderPromised = false
        }
    }
    
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView ()
    }
}
