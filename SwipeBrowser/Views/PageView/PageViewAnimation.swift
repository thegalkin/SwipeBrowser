//
// Created by Никита Галкин on 12.07.2022.
//

import SwiftUI

extension PageView {

//    MARK: - Rotation Effect For Current Page
    var currentPageRotationScale: Binding<Angle> {
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

    var currentPageScaleScale: Binding<Double> {
        if pageOffset == 0 {
            let binding: Binding = Binding.constant(Double(1))
            return binding
        } else {
            let res: Double = Double(1) - abs(pageOffset / screenWidth )
            let binding: Binding = Binding.constant(res)
            return binding
        }
    }

    var currentPageYOffset: Binding<CGFloat> {
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
    var newPageRotationScale: Binding<Angle> {
        let scale: Double = .init(abs(self.rotationProgressPercentageCGFloat * CGFloat(90.0) - CGFloat(90)))
        let angle: Angle = Angle.degrees(scale)
        let binding: Binding = Binding.constant(angle)
        return binding
    }

    var newPageScaleScale: Binding<Double> {
        let res: Double = self.rotationProgressPercentageDouble
        let binding: Binding = Binding.constant(res)
        return binding
    }

    var newPageYOffset: Binding<CGFloat> {
        let startOffset: CGFloat = self.screenHeight
        let res: CGFloat = startOffset - screenHeight * self.rotationProgressPercentageCGFloat
        let binding: Binding = Binding.constant(res)
        return binding
    }

    var newPageXOffset: Binding<CGFloat> {
        let startOffset: CGFloat = self.screenWidth
        let res: CGFloat = startOffset + self.pageOffset
        let binding: Binding<CGFloat> = Binding.constant(res)
        return binding
    }

    var rotationProgressPercentageCGFloat: CGFloat {
        let positiveHorizontalOffset: CGFloat = abs(self.pageOffset)
        let percent: CGFloat = positiveHorizontalOffset / self.screenWidth
        return percent
    }

    var rotationProgressPercentageDouble: Double {
        let positiveHorizontalOffset: Double = abs(Double(self.pageOffset))
        let percent: Double = positiveHorizontalOffset / self.screenWidth
        return percent
    }

//    MARK: - Common Left Pan Gesture
    var leftPanGesture: some Gesture {
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
}
