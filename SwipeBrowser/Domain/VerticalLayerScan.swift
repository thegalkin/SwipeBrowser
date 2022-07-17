//
//  VerticalLayerScan.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 11.07.2022.
//

import Foundation
import SwiftUI

struct VerticalLayerScan {
    private var top: UIView?
    private var bottom: UIView?
}

extension VerticalLayerScan {

    public mutating func scanSafeArea(for view: UIView) {
        self.top = self.getTopSafeAreaCut(for: view)
        self.bottom = getBottomSafeAreaCut(for: view)
    }

    //cut from UIView with given size
    private func getTopSafeAreaCut (for uiView: UIView) -> UIView {
//        let topSafeAreaStart: CGPoint = .init(x: 0, y: 0)
//        let topSafeAreaEnd: CGPoint = .init(x: uiView.frame.width, y: SafeAreaRegions.top ?? 40)
//        let safeAreaSize: CGSize = .init(width: topSafeAreaEnd.x - topSafeAreaStart.x, height: topSafeAreaEnd.y - topSafeAreaStart.y)
//        let safeAreaRect: CGRect = .init(origin: topSafeAreaStart, size: safeAreaSize)

        let topSafeAreaView: UIView = getCopyOfView(for: uiView, with: SafeAreaRegions.topRectangle ?? .zero)
        topSafeAreaView.clipsToBounds = true 
        return topSafeAreaView
    }
    
    //cut from UIView with given size
    private func getBottomSafeAreaCut (for uiView: UIView) -> UIView {
//        let bottomSafeAreaStart: CGPoint = .init(x: uiView.frame.origin.x, y: uiView.frame.height)
//        let bottomSafeAreaEnd: CGPoint = .init(x: uiView.frame.width, y: UIScreen.main.bounds.height)
//        let safeAreaSize: CGSize = .init(width: bottomSafeAreaEnd.x - bottomSafeAreaStart.x, height: bottomSafeAreaEnd.y - bottomSafeAreaStart.y)
//        let safeAreaRect: CGRect = .init(origin: bottomSafeAreaStart, size: safeAreaSize)



        let bottomSafeAreaView: UIView = getCopyOfView(for: uiView, with: SafeAreaRegions.bottomRectangle ?? .zero)
        bottomSafeAreaView.clipsToBounds = true
        return bottomSafeAreaView
    }
    
    private func getCopyOfView(for uiView: UIView, with rect: CGRect) -> UIView {
        let copyOfView: UIView = .init()
        copyOfView.bounds = rect
        copyOfView.layer.addSublayer(uiView.layer)
        return copyOfView
    }
}

//Drawing
extension VerticalLayerScan {
    func TopView () -> AnyView {
        if let top {
//            let uiView: UIView = getUIViewFromCALayer(top)
            return VerticalSafeAreaBackgroundView(uiView: top).eraseToAnyView()
        } else {
            return EmptyView().eraseToAnyView()
        }
    }

    func BottomView () -> AnyView {
        if let bottom {
//            let uiView: UIView = getUIViewFromCALayer(bottom)
            return VerticalSafeAreaBackgroundView(uiView: bottom).eraseToAnyView()
        } else {
            return EmptyView().eraseToAnyView()
        }
    }
}

fileprivate struct VerticalSafeAreaBackgroundView: UIViewRepresentable {
    let uiView: UIView
    
    func makeUIView(context: Context) -> some UIView {
        uiView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
