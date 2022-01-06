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
    
    @State private var interactableText: String = .init()
    @State private var isShowingInteractableTextField: Bool = false
//    @FocusState private var focusState: FocusState = Self.focusState.url
    
    let placeholder: String = String("Search or site...")
    
    var body: some View {
        BackgroundRectangle.overlay{
            if isShowingInteractableTextField{
                
            } else {
                AddressOrSearchWord
            }
            
        }
        .frame(width: .infinity, height: 34)
        .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
    }
    
    //TODO: - добавить поисковое слово из поискового запроса
    private var AddressOrSearchWord: some View {
        Text(self.pageViewModel.currentAddress?.host ?? "")
            .foregroundColor(.white)
    }
    
    private var interactableTextField: some View {
        TextField(self.placeholder, text: self.$interactableText)
            .foregroundColor(.white)
            .onSubmit {
                self.onBottomTextFieldSubmit ()
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.primary)
            
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
            .onTapGesture {
                withAnimation(Animation.easeInOut) {
                    self.isShowingInteractableTextField = true
                }
            }
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
        self.isShowingInteractableTextField = false
        //TODO: validate and open + autocheck 
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
