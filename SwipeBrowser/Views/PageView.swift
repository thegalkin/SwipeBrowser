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
            self.pageViewModel.setAddress(with: self.open)
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
        GeometryReader { geo in
            VStack {
                WebContentView ()
                    .environmentObject(pageViewModel)
                    .offset(x: 0, y: -self.offset)
                    .frame(height: geo.size.height + self.offset)
            }
        }
    }

    private var currentPageWithEffect: some View {
        ZStack{
            currentPage
                .rotationEffect(self.currentPageRotationScale.wrappedValue)
                .scaleEffect(self.currentPageScaleScale.wrappedValue)
                .offset(x: pageOffset, y: currentPageYOffset.wrappedValue)
            leftPanGestureRecogniserView
        }

    }
    
//    MARK: - New Page
    private var newPage: some View {
        GeometryReader { geo in
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
    
//    MARK: - Rotation Effect For Current Page
    private var currentPageRotationScale: Binding<Angle> {
        if -pageOffset > minSwipeOffset {
            let angle: Angle = Angle.degrees(Double(-90.0))
            let binding: Binding = Binding.constant(angle)
            return binding
        } else {
            let scale: Double = .init(Double(pageOffset / screenWidth * CGFloat(180)))
            let angle: Angle = Angle.degrees(scale)
            let binding: Binding = Binding.constant(angle)
            return binding
        }
    }
    
    private var currentPageScaleScale: Binding<Double> {
        if pageOffset == 0 {
            let binding: Binding = Binding.constant(Double(1))
            return binding
        } else {
            let res: Double = Double(1) - abs(pageOffset / screenWidth )
            let binding: Binding = Binding.constant(res)
            return binding
        }
    }
    
    private var currentPageYOffset: Binding<CGFloat> {
        if self.pageOffset == 0 {
            let binding: Binding = Binding.constant(CGFloat(0))
            return binding
        } else {
            let res: CGFloat = -self.pageOffset * 1.5
            let binding: Binding = Binding.constant(res)
            return binding
        }
        
    }
    
    //    MARK: - Rotation Effect For New Page
    private var newPageRotationScale: Binding<Angle> {
        let scale: Double = .init(abs(self.rotationProgressPercentageCGFloat * CGFloat(90.0) - CGFloat(90)))
        let angle: Angle = Angle.degrees(scale)
        let binding: Binding = Binding.constant(angle)
        return binding
    }
    
    private var newPageScaleScale: Binding<Double> {
        let res: Double = self.rotationProgressPercentageDouble
        let binding: Binding = Binding.constant(res)
        return binding
    }
    
    private var newPageYOffset: Binding<CGFloat> {
        let startOffset: CGFloat = self.screenHeight
        let res: CGFloat = startOffset - screenHeight * self.rotationProgressPercentageCGFloat
        let binding: Binding = Binding.constant(res)
        return binding
    }
    
    private var newPageXOffset: Binding<CGFloat> {
        let startOffset: CGFloat = self.screenWidth
        let res: CGFloat = startOffset + self.pageOffset
        let binding: Binding<CGFloat> = Binding.constant(res)
        return binding
    }
    
    private var rotationProgressPercentageCGFloat: CGFloat {
        let positiveHorizontalOffset: CGFloat = abs(self.pageOffset)
        let percent: CGFloat = positiveHorizontalOffset / self.screenWidth
        return percent
    }
    
    private var rotationProgressPercentageDouble: Double {
        let positiveHorizontalOffset: Double = abs(Double(self.pageOffset))
        let percent: Double = positiveHorizontalOffset / self.screenWidth
        return percent
    }
    
//    MARK: - Common Left Pan Gesture
    private var leftPanGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { changePos in
                
                let startPos: CGFloat = changePos.startLocation.x
                let currentPos: CGFloat = changePos.location.x
                
                if startPos > self.screenWidth - self.minSwipeOffset {
                    self.pageOffset = currentPos - screenWidth
                }
            }
            .onEnded { endPos in
                let startPos: CGFloat = endPos.startLocation.x
                let currentPos: CGFloat = endPos.location.x
                let milliseconds: Int = Int(self.pageDissapearTime) * 1000
                let speed: CGFloat = endPos.predictedEndLocation.x - currentPos
                
                if (currentPos <= self.minSwipeOffset || speed < -15) && startPos > minSwipeOffset {
                    withAnimation(.easeInOut(duration: self.pageDissapearTime)) {
                        self.pageOffset = -self.screenWidth
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
                        //TODO: отправка страницы в background?
                    }
                } else {
                    withAnimation(.easeOut) {
                        self.pageOffset = 0
                    }
                }
            }
    }
    
    private func presentNewTab () {
        withAnimation {
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
