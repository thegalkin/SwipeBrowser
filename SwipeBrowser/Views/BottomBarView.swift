//
//  BottomBarView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
/**Нижний бар с адресной строкой**/
struct BottomBarView: View {
    @EnvironmentObject var pageViewModel: PageViewModel
    @EnvironmentObject var browserController: BrowserController
    
    var body: some View {
            BackgroundRectangle.overlay{
                AddressOrSearchWord
            }
            .frame(width: .infinity, height: 34)
            .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
    }
    
    //TODO: - добавить поисковое слово из поискового запроса
    private var AddressOrSearchWord: some View {
        Text(self.pageViewModel.currentAddress?.host ?? "")
            .foregroundColor(.white)
    }
    
    private var BackgroundRectangle: some View {
        GeometryReader { size in
            Rectangle ()
                .background(.thinMaterial)
                .overlay {
                    HStack{
                        tabsButton
                        addressField(in: size)
                        newTabButton
                    }
                }
        }
    }
    
    @ViewBuilder
    private func addressField(in size: GeometryProxy) -> some View{
        RoundedRectangle(cornerRadius: 5)
            .frame(
                height: size.size.height - 10,
                alignment: .center
            )
            .opacity(0.2)
    }
    
    private var tabsButton: some View {
        Button {
            self.pageViewModel.isShowingTabsView = true
        } label: {
            Image(systemName: "rectangle.stack.fill")
                .foregroundStyle(.bar)
        }
        .padding()

    }
    
    private var newTabButton: some View {
        Button {
            self.browserController.openNewEmptyPage ()
        } label: {
            Image(systemName: "rectangle.stack.fill.badge.plus")
                .foregroundStyle(.green, .bar)
        }
        .padding()
    }
}


