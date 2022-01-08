//
//  WindMillTransition.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 08.01.2022.
//

import SwiftUI
fileprivate let screenWidth: CGFloat = UIScreen.main.bounds.width
extension AnyTransition {
    static var windmillRotationExit: AnyTransition {
        .modifier(active: WindmillRotationModifier(pageOffset: 0, isOpening: false),
                  identity: WindmillRotationModifier(pageOffset: screenWidth, isOpening: false))
    }
    static var windmillRotationEnter: AnyTransition {
        .modifier(active: WindmillRotationModifier(pageOffset: 0, isOpening: true),
                  identity: WindmillRotationModifier(pageOffset: screenWidth, isOpening: true))
    }
}

struct WindmillRotationModifier: ViewModifier {
    
    var pageOffset: CGFloat
    let isOpening: Bool
    
    let minSwipeOffset: CGFloat = UIScreen.main.bounds.width / 2
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let pageDissapearTime: Double = 0.5
    let offset: CGFloat = 40
    
    func body(content: Content) -> some View {
        
        if isOpening {
            //newPage
            content
                .rotationEffect(self.newPageRotationScale.wrappedValue, anchor: .center)
                .scaleEffect(self.newPageScaleScale.wrappedValue)
                .offset(x: self.newPageXOffset.wrappedValue, y: self.newPageYOffset.wrappedValue)
        } else {
            //oldPage
            content
                .rotationEffect(self.currentPageRotationScale.wrappedValue)
                .scaleEffect(self.currentPageScaleScale.wrappedValue)
                .offset(x: pageOffset, y: currentPageYOffset.wrappedValue)
        }
        
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
}
