//
//  PageView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
/** Уровень свайпов*/
struct PageView: View {
    @StateObject var pageViewModel: PageViewModel = .init()
    @EnvironmentObject var browserController: BrowserController
    
    @State var pageOffset: CGFloat = 0
    @State var minSwipeOffset: CGFloat = UIScreen.main.bounds.width / 2
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let pageDissapearTime: Double = 0.5
    let offset: CGFloat = 40
    
    var body: some View {
        ZStack {
            contentWithEffect
            VStack {
                Spacer ()
                Spacer ()
                BottomBarView ()
                    .environmentObject(pageViewModel)
            }
        }
    }
    //TODO: do a barrel row with new page
    var content: some View {
        GeometryReader { geo in
            VStack {
                WebContentView ()
                    .environmentObject(pageViewModel)
                    .offset(x: 0, y: -self.offset)
                    .frame(height: geo.size.height + self.offset)
                
                //                        .offset(x: 0, y: -self.offset*2)
            }
        }
    }
    
    var contentWithEffect: some View {
        content
            .rotationEffect(self.rotationScale.wrappedValue)
            .scaleEffect(self.scaleScale.wrappedValue)
            .gesture(self.leftPanGesture)
            .offset(x: pageOffset, y: yOffset.wrappedValue)
    }
    
    private var rotationScale: Binding<Angle> {
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
    
    private var scaleScale: Binding<Double> {
        if pageOffset == 0 {
            let binding: Binding = Binding.constant(Double(1))
            return binding
        } else {
            let res: Double = Double(1) - abs(pageOffset / screenWidth )
            let binding: Binding = Binding.constant(res)
            return binding
        }
    }
    
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
                
                let currentPos: CGFloat = endPos.location.x
                let milliseconds: Int = Int(self.pageDissapearTime) * 1000
                let speed: CGFloat = endPos.predictedEndLocation.x - currentPos
                
                if currentPos <= self.minSwipeOffset || speed < -15 {
                    withAnimation(.easeInOut(duration: self.pageDissapearTime)) {
                        self.pageOffset = -self.screenWidth
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
                        //отправка страницы в background?
                    }
                } else {
                    withAnimation(.easeOut) {
                        self.pageOffset = 0
                    }
                }
            }
    }
    
    private var yOffset: Binding<CGFloat> {
        if self.pageOffset == 0 {
            let binding: Binding = Binding.constant(CGFloat(0))
            return binding
        } else {
            let res: CGFloat = -self.pageOffset * 1.5
            let binding: Binding = Binding.constant(res)
            return binding
        }
        
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView ()
    }
}
