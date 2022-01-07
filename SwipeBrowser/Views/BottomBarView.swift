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
        BackgroundRectangle
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
                let url: URL? = self.pageViewModel.currentAddress
                    if let url: URL = url {
                    let host: String = url.host ?? String()
                    return host
                } else {
                    let val: String = self.interactableText
                    return val
                }
            },
            set: { (newVal: String) in
                self.interactableText = newVal
            }
        )
    }
    //TODO: - добавить поисковое слово из поискового запроса
    private var addressOrSearchWord: some View {
//        Text(self.pageViewModel.currentAddress?.host ?? "")
        Text("Shazoo.ru")
            .foregroundColor(.white)
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
    
    private var BackgroundRectangle: some View {
        GeometryReader { size in
            Rectangle ()
                .background(.thinMaterial)
                .overlay {
                    HStack {
                        tabsButton
                        addressField(in: size)
                        newTabButton
                    }
                }
        }
    }
    
    @ViewBuilder
    private func addressField(in size: GeometryProxy) -> some View {
        ZStack(alignment: Alignment.center) {
            RoundedRectangle(cornerRadius: 5)
                .opacity(0.2)
                .onTapGesture {
                    withAnimation(Animation.easeInOut) {
                        self.isShowingInteractableTextField = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)){
                            self.isSerachFieldFocused = true
                        }
                    }
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
        .disabled(!self.browserController.newPageButtonIsOn)
    }
    
    private func onBottomTextFieldSubmit () {
        self.isSerachFieldFocused = false
        
        self.isShowingInteractableTextField = false
        
        self.browserController.openNewPage(having: self.interactableText)
        //TODO: validate and open + autocheck 
    }

}


struct NewPageView_Previews: PreviewProvider {
    @StateObject static var browserController: BrowserController = .init()
    @StateObject static var pageViewModel: PageViewModel = .init()
    static var previews: some View {
        ZStack {
            NewPageView ()
            BottomBarView()
        }
        .environmentObject(pageViewModel)
        .environmentObject(browserController)
        .onAppear {
            self.pageViewModel.setAddress(with: URL(string: "https://shazoo.ru")!)
        }
        //        ContentView ()
    }
}

//
//fileprivate struct BottomTextFieldInteractable: View {
//    //inner
//    @Binding var text: String
//    @Binding var isShowingInteractableTextField: Bool
//
//    @State var showingPlaceholder: Bool = true
//
//
//    //Design
//    @Environment (\.colorScheme) var colorScheme
//    @State var containerHeight: CGFloat = 0
//
//    private var textIsValid: Bool {
//        true
//    }
//
//    var body: some View {
//        HStack {
//            ButtomCommentViewRep (text: $text, containerHeight: $containerHeight)
//                .frame (height: containerHeight <= 120 ? containerHeight : 120)
//                .cornerRadius (10)
//                .padding (.leading, 10)
//            Button (action: searchButtonWasPressed) {
//                Image (systemName: "arrow.up.circle.fill")
//                    .accentColor (Color ("accent"))
//                    .font (.system (size: 30))
//                    .padding (.trailing, 10)
//            }.disabled (!textIsValid)
//        }.padding (7)
//    }
//
//    private func searchButtonWasPressed () {
//        if textIsValid {
//            //TODO: search query or go to site
//            DispatchQueue.init (label: "clearing comment").sync {
//                text = ""
//                self.hideKeyboard()
//                containerHeight = 0
//            }
//        }
//    }
//}
//
//fileprivate struct ButtomCommentViewRep: UIViewRepresentable {
//
//    let placeholder: String = String("Search or site...")
//
//    @Binding var text: String
//    @Binding var containerHeight: CGFloat
//
//    func makeCoordinator () -> Coordinator {
//        return ButtomCommentViewRep.Coordinator (parent: self)
//    }
//
//    func makeUIView (context: Context) -> UITextView {
//        let textView = UITextView ()
//
//        textView.text = placeholder
//        textView.textColor = .placeholderText
//        textView.backgroundColor = .clear
//        textView.font = .systemFont (ofSize: 17)
//        textView.delegate = context.coordinator
//
//        return textView
//    }
//
//    func updateUIView (_ uiView: UITextView, context: Context) {
//        DispatchQueue.main.async {
//            if containerHeight == 0 {
//                containerHeight = uiView.contentSize.height
//            }
//            if uiView.text != placeholder {
//                uiView.text = text
//            }
//        }
//    }
//
//    class Coordinator: NSObject, UITextViewDelegate {
//        var parent: ButtomCommentViewRep
//
//        init (parent: ButtomCommentViewRep) {
//            self.parent = parent
//        }
//
//        func textViewDidBeginEditing (_ textView: UITextView) {
//            if textView.text == parent.placeholder {
//                textView.text = ""
//                textView.textColor = .label
//            }
//        }
//
//        func textViewDidChange (_ textView: UITextView) {
//            parent.text = textView.text
//            parent.containerHeight = textView.contentSize.height
//        }
//
//
//        func textViewDidEndEditing (_ textView: UITextView) {
//            textView.text = parent.text
//            if textView.text == "" {
//                textView.text = parent.placeholder
//                textView.textColor = .placeholderText
//            }
//        }
//    }
//}
//
