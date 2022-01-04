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
        Image("stunt_double")
            .resizable()
            .scaledToFill()
        //        WebView(url: $pageViewModel.currentAddress)
    }
}

struct WebContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView ()
    }
}

struct WebView: UIViewRepresentable {
    
    @Binding var url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = url else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
}
