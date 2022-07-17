//
// Created by Никита Галкин on 12.07.2022.
//

import SwiftUI

///Scanning
extension PageView {
    public func startTimer() {
        guard self.pageViewModel.topAndBottomSafeAreaScanningTimer == nil else { return }
        self.pageViewModel.topAndBottomSafeAreaScanningTimer = Timer
        .scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in scanTask() }
    }

    public func stopTimer() {
        self.pageViewModel.topAndBottomSafeAreaScanningTimer?.invalidate()
        self.pageViewModel.topAndBottomSafeAreaScanningTimer = nil
    }

    //function that gets UIView from SwiftUI View
    private func getUIView () -> UIView {
        let uiView: UIView = UIHostingController.init(rootView: self.body).view
        return uiView
    }

    private func scanTask () {
        guard let uiView: UIView = self.pageViewModel.currentWebView else { return }
        self.pageViewModel.topAndBottomSafeAreaCalayerScans.scanSafeArea(for: uiView)
    }
}

///insertScanned
extension PageView {
    var topSafeAreaScan: some View {
        self.pageViewModel.topAndBottomSafeAreaCalayerScans.TopView()
            .frame(maxHeight: 40)
            .edgesIgnoringSafeArea(.all)
    }

    var bottomSafeAreaScan: some View {
        self.pageViewModel.topAndBottomSafeAreaCalayerScans.BottomView()
            .frame(maxHeight: 40)
            .edgesIgnoringSafeArea(.all)
    }
}
