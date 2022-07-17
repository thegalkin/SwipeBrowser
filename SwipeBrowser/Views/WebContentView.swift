//
//  WebContentView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
import WebKit
import Combine
/** Репрезентация сайтов как она есть*/
struct WebContentView: View {
    @EnvironmentObject var pageViewModel: PageViewModel
    var body: some View {
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
    @EnvironmentObject var pageViewModel: PageViewModel
    @EnvironmentObject var browserController: BrowserController
    @State private var cancellables: Set<AnyCancellable> = .init()
    
    func makeUIView(context: Context) -> WKWebView {
        let wkWebView: WKWebView = .init()
        let refreshControl: UIRefreshControl = .init()
        refreshControl.backgroundColor = .clear
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.scrollView.addSubview(refreshControl)
        wkWebView.uiDelegate = context.coordinator
        wkWebView.navigationDelegate = context.coordinator
        setUpObservers(for: wkWebView)
        saveUIViewToPageViewModel(for: wkWebView)
        return wkWebView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = url else {
            return
        }
        if webView.url?.deletingLastPathSlash() != url.deletingLastPathSlash() {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func saveUIViewToPageViewModel (for uiView: UIView) {
        self.pageViewModel.currentWebView = uiView
    }
    
    private func setUpObservers (for wkWebView: WKWebView) {
        wkWebView.url
            .publisher
            .sink { (newUrl: URL?) in
                self.url = newUrl
            }
            .store(in: &cancellables)
    }
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var control: WebView
        
        init(_ control: WebView) {
            self.control = control
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            // handle the refresh event
            control.webViewReloadOrdered = true
            sender.endRefreshing()
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            guard let url = navigationAction.request.url else {return nil}
            self.control.browserController.openNewPage(with: url)
            return nil
        }
        
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            if let url: URL = webView.url {
                self.control.url = url
            }
        }
    }
}

