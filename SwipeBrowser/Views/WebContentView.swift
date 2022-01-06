//
//  WebContentView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
import WebKit
/** Репрезентация сайтов как она есть*/
struct WebContentView: View {
    @EnvironmentObject var pageViewModel: PageViewModel
    var body: some View {
//        Image("stunt_double")
//            .resizable()
//            .scaledToFill()
                WebView(url: $pageViewModel.currentAddress)
    }
}

struct WebContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView ()
    }
}

struct WebView: UIViewRepresentable {
    
    @Binding var url: URL?
    @State private var webViewReloadOrdered: Bool = false
    
    func makeUIView(context: Context) -> WKWebView {
        let wkWebView: WKWebView = .init()
        let refreshControll: UIRefreshControl = .init()
        refreshControll.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.scrollView.addSubview(refreshControll)
        return wkWebView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var control: WebView
        
        init(_ control: WebView) {
            self.control = control
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            // handle the refresh event
            control.webViewReloadOrdered = true
            sender.endRefreshing()
        }
    }
}

//final fileprivate class WebContentCoordinator {
//    var
//    init(refreshControll: UIRefreshControl) {
//
//    }

//}
