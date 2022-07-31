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
    ///to solve chicken and egg problem with incomming url from textfield and redirect url(meanwhile having a constant reload of the view)
    @State var previousWebViewURL: URL?
    
    @State private var queue: DispatchQueue = .init(label: String("WebViewQueue"), qos: DispatchQoS.userInteractive)
    
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
        self.previousWebViewURL = self.url
        return wkWebView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        checkForRedirect(webView)
        
        compareToAddressFieldAndCheckForBlankPage(webView)
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
    
    private func isBlankPage (_ webView: WKWebView) -> Bool {
        var err: Error?
        Task {
            err = await withCheckedContinuation { continuation in
                webView.evaluateJavaScript("document.querySelector('body').innerHTML") { (result, error) in
                    continuation.resume(returning: error)
                }
            }
        }
        
        return err != nil
    }
    ///to solve chicken and egg problem with incomming url from textfield and redirect url(meanwhile having a constant reload of the view)
    
    private func checkForRedirect(_ webView: WKWebView) {
        //FIXME: реши проблему курицы и яица в первую очередь - она ломает загрузку страниц
        DispatchQueue.main.async {
            let urlWithDeletedLastPathSlash: URL? = webView.url?.deletingLastPathSlash()
            if urlWithDeletedLastPathSlash != self.previousWebViewURL {
                self.previousWebViewURL = urlWithDeletedLastPathSlash
                self.url = urlWithDeletedLastPathSlash
            }
        }
    }
    
    private func compareToAddressFieldAndCheckForBlankPage(_ webView: WKWebView) {
        DispatchQueue.main.async {
            guard let url = url else {
                return
            }
            if webView.url?.deletingLastPathSlash() != url.deletingLastPathSlash() || isBlankPage(webView) {
                if url.isValid {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
            }
        }
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
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("didCommitNavigation - content arriving?")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("didFailNavigation")
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("didStartProvisionalNavigation")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("didFailProvisionalNavigation")
        }
                
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("didFinishNavigation")
        }
    }
}

