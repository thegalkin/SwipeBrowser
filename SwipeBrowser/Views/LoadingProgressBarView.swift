//
//  LoadingProgressBarView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 31.07.2022.
//

import SwiftUI
import WebKit

struct LoadingProgressBar: View {
    @EnvironmentObject var pageViewModel: PageViewModel

    @State private var checkTimer: Timer?
    @State private var checkToggle: UUID = UUID ()

    var body: some View {
        HStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * currentLoadingProgress.wrappedValue, height: 4)
                .foregroundColor(Color.accentColor)
                .animation(Animation.easeInOut, value: currentLoadingProgress.wrappedValue)
            Spacer()
                .frame(width: UIScreen.main.bounds.width - UIScreen.main.bounds.width * currentLoadingProgress.wrappedValue, height: 4)
                .animation(Animation.easeInOut, value: currentLoadingProgress.wrappedValue)
        }
        .blur(radius: currentLoadingProgress.wrappedValue != 1 ? 0 : 100)
        .animation(Animation.easeInOut(duration: 4), value: currentLoadingProgress.wrappedValue != 1)
    }
    
    public var currentLoadingProgress: Binding<Double> {
        return Binding.constant(pageViewModel.bottomBar.loadingProgress)
    }
}
