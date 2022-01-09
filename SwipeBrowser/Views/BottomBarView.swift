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
    
    let isInTabsView: Bool
    
    ///empty if there is a pageViewModel's nonempty
    @State private var interactableText: String = .init()
    
    @State private var isShowingInteractableTextField: Bool = false
    @FocusState private var isSerachFieldFocused: Bool
    
    let placeholder: String = String("Search or site...")
    
    var body: some View {
        VStack {
            resignFromKeyboardGestureRecogniserView
            content
        }
    }
    
    
    private var content: some View {
        backgroundRectangle
            .frame(width: .infinity, height: 34)
            .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
    }
    
    @ViewBuilder
    private var resignFromKeyboardGestureRecogniserView: some View {
        if self.isShowingInteractableTextField {
            Color.white
                .opacity(0.001)
                .onTapGesture {
                    withAnimation(Animation.easeInOut) {
                        self.isSerachFieldFocused = false
                        self.isShowingInteractableTextField = false
                    }
                }
        } else {
            Spacer ()
        }
    }
    
    private var currentAddressStringBinding: Binding<String> {
        Binding(
            get: {
                if self.pageViewModel.isShowingNewTabView{
                    let val: String = self.interactableText
                    return val
                } else {
                    let url: URL? = self.pageViewModel.currentAddress
                    if let url: URL = url {
                        let host: String = url.host ?? String()
                        return host
                    } else {
                        let val: String = self.interactableText
                        return val
                    }
                }
            },
            set: { (newVal: String) in
                self.interactableText = newVal
            }
        )
    }
    @ViewBuilder
    //TODO: - добавить поисковое слово из поискового запроса
    private var addressOrSearchWord: some View {
        if self.pageViewModel.isShowingNewTabView {
            Text(self.placeholder)
                .foregroundColor(.white)
        } else {
            Text(self.pageViewModel.currentAddress?.host ?? "")
                .foregroundColor(.white)
        }
    }
    
    private var interactableTextField: some View {
        TextField("", text: self.currentAddressStringBinding)
//            .tint(Color.white)
            .focused(self.$isSerachFieldFocused)
            .placeholder(when: self.currentAddressStringBinding.wrappedValue.isEmpty) {
                Text(self.placeholder)
                    .foregroundColor(.white)
            }
            
            .foregroundColor(.white)
            .onSubmit {
                self.onBottomTextFieldSubmit ()
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            
            
    }
    
    private var backgroundRectangle: some View {
        GeometryReader { size in
            Rectangle ()
                .background(.thinMaterial)
                .overlay {
                    buttomButtons(size: size)
                }
        }
    }
    
    @ViewBuilder
    private func buttomButtons(size: GeometryProxy) -> some View {
        if self.isInTabsView {
            tabsViewButtons
        } else {
            pageButtons(size: size)
        }
    }
    
    private func pageButtons(size: GeometryProxy) -> some View {
        HStack {
            tabsButton
            addressField(in: size)
            rightBarButton
        }
    }
    
    private var tabsViewButtons: some View {
        HStack {
            tabsButton
            Spacer ()
            settingsButton
            Spacer ()
            rightBarButton
        }
    }
    
    private var settingsButton: some View {
        Button {
            self.browserController.isShowingSettingsSheet = true
        } label: {
            Image(systemName: "gear.circle.fill")
                .foregroundStyle(.bar)
        }
        .padding()
    }
    
    @ViewBuilder
    private func addressField(in size: GeometryProxy) -> some View {
        ZStack(alignment: Alignment.center) {
            RoundedRectangle(cornerRadius: 5)
                .opacity(0.2)
                .onTapGesture {
                    self.onQuickPickAddressContainerTapped ()
                }
            GeometryReader { textFieldSize in
                if self.isShowingInteractableTextField {
                    interactableTextField
                        .transition(
                            AnyTransition.offset(x: CGFloat(textFieldSize.size.width / CGFloat(3)),
                                                 y: CGFloat(0)
                                                )
                                .combined(with: AnyTransition.opacity)
                        )
                } else {
                    addressOrSearchWord
//                        .transition(.offset(x: (textFieldSize.size.width / CGFloat(2)), y: CGFloat(0)))
                        .transition(.asymmetric(insertion: AnyTransition.opacity.animation(Animation.easeOut(duration: 1)),
                                                removal:
                            AnyTransition.opacity.animation(Animation.easeOut(duration: 0.1))
                                               )
                                    )
                        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
                        .onTapGesture {
                            self.onQuickPickAddressContainerTapped ()
                        }
                }
            }
            
            
        }
        .frame(
            height: size.size.height - 10,
            alignment: .center
        )
    }
    
    private var tabsButton: some View {
        Button {
            self.browserController.isShowingTabsView.toggle()
        } label: {
            Image(systemName: "rectangle.stack.fill")
                .foregroundStyle(.bar)
        }
        .padding()
    }
    
    @ViewBuilder
    private var rightBarButton: some View {
        //такая странная реализация обусловленна отсутвием в TabsView PageViewModel
        if !self.browserController.isShowingTabsView{
            if self.pageViewModel.isShowingNewTabView {
                searchButton
            } else {
                newTabButton
            }
        } else {
            newTabButton
        }
    }
    
    private var searchButton: some View {
        Button {
            self.onBottomTextFieldSubmit()
        } label: {
            if self.isShowingInteractableTextField {
                Image(systemName: "magnifyingglass.circle")
                    .foregroundStyle(.green, .bar)
            } else {
                Image(systemName: "magnifyingglass.circle")
                    .foregroundStyle(.gray)
            }
            
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
        .disabled(!self.browserController.newPageButtonIsOn)
    }
    
    private func onBottomTextFieldSubmit () {
        self.isSerachFieldFocused = false
        self.isShowingInteractableTextField = false
        
        self.browserController.openNewPage(having: self.interactableText)
        //TODO: validate and open + autocheck 
    }
    
    private func onQuickPickAddressContainerTapped () {
        withAnimation(Animation.easeInOut) {
            self.isShowingInteractableTextField = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)){
                self.isSerachFieldFocused = true
            }
        }
    }

}


struct NewPageView_Previews: PreviewProvider {
    @StateObject static var browserController: BrowserController = .init()
    @StateObject static var pageViewModel: PageViewModel = .init()
    static var previews: some View {
        ZStack {
            NewPageView ()
            BottomBarView(isInTabsView: false)
        }
        .environmentObject(pageViewModel)
        .environmentObject(browserController)
        .onAppear {
            self.pageViewModel.isShowingNewTabView = true
            self.pageViewModel.setAddress(with: URL(string: "https://shazoo.ru")!)
        }
        //        ContentView ()
    }
}
