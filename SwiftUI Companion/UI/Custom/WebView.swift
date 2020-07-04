//
//  WebView.swift
//  SwiftUI Companion
//
//  Created by Jerry Hanks on 03/07/2020.
//  Copyright © 2020 Jerry Okafor. All rights reserved.
//

import SwiftUI
import WebKit
/*
  A weird case: if you change WebViewWrapper to struct cahnge in WebViewStateModel will never call updateUIView
 */
class WebViewStateModel: ObservableObject {
    @Published var pageTitle: String = "Web View"
    @Published var loading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var goBack: Bool = false
}

struct WebView: View {
     enum NavigationAction {
           case decidePolicy(WKNavigationAction,  (WKNavigationActionPolicy) -> Void)
           case didRecieveAuthChallange(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
           case didStartProvisionalNavigation(WKNavigation)
           case didReceiveServerRedirectForProvisionalNavigation(WKNavigation)
           case didCommit(WKNavigation)
           case didFinish(WKNavigation)
           case didFailProvisionalNavigation(WKNavigation,Error)
           case didFail(WKNavigation,Error)
       }
       
    @ObservedObject var webViewStateModel: WebViewStateModel
    
    private var actionDelegate: ((_ navigationAction: WebView.NavigationAction) -> Void)?
    
    
    let uRLRequest: URLRequest?
    let htmlString:String?
    
    
    var body: some View {
        
        if let uRLRequest = self.uRLRequest {
            return WebViewWrapper(webViewStateModel: webViewStateModel,
                                  action: actionDelegate,
                                  request: uRLRequest)
        }
        
        if let htmlString = self.htmlString{
            return WebViewWrapper(webViewStateModel: webViewStateModel,
                                  action: actionDelegate,
                                  htmlString: htmlString)
        }
        
        return WebViewWrapper(webViewStateModel: webViewStateModel,
                                         action: actionDelegate,
                                         request: URLRequest(url: URL(string: "www.google.com")!))
    }
    /*
     if passed onNavigationAction it is mendetory to complete URLAuthenticationChallenge and decidePolicyFor callbacks
    */
    
    init(uRLRequest: URLRequest, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebView.NavigationAction) -> Void)?) {
        self.htmlString = nil
        self.uRLRequest = uRLRequest
        self.webViewStateModel = webViewStateModel
        self.actionDelegate = onNavigationAction
    }
    
    init(url: URL, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebView.NavigationAction) -> Void)? = nil) {
        self.init(uRLRequest: URLRequest(url: url),
                  webViewStateModel: webViewStateModel,
                  onNavigationAction: onNavigationAction)
    }
    
    init(htmlString: String, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebView.NavigationAction) -> Void)? = nil) {
        
        self.htmlString = htmlString
        self.uRLRequest = nil
        self.webViewStateModel = webViewStateModel
        self.actionDelegate = onNavigationAction
    }
}

/*
  A weird case: if you change WebViewWrapper to struct cahnge in WebViewStateModel will never call updateUIView
 */

final class WebViewWrapper : UIViewRepresentable {
    @ObservedObject var webViewStateModel: WebViewStateModel
    
    let action: ((_ navigationAction: WebView.NavigationAction) -> Void)?
    let request: URLRequest?
    let htmlString:String?
      
    init(webViewStateModel: WebViewStateModel, action: ((_ navigationAction: WebView.NavigationAction) -> Void)?,
    request: URLRequest) {
        self.action = action
        self.request = request
        self.htmlString = nil
        self.webViewStateModel = webViewStateModel
    }
    
    
    init(webViewStateModel: WebViewStateModel, action: ((_ navigationAction: WebView.NavigationAction) -> Void)?,htmlString:String) {
        self.action = action
        self.request = nil
        self.htmlString = htmlString
        self.webViewStateModel = webViewStateModel
    }
    
    
    func makeUIView(context: Context) -> WKWebView  {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        
        if let request = self.request{
            view.load(request)
        }
        
        if let htmlString = self.htmlString{
            view.loadHTMLString(htmlString, baseURL: nil)
        }
        
        return view
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.canGoBack, webViewStateModel.goBack {
            uiView.goBack()
            webViewStateModel.goBack = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(action: action, webViewStateModel: webViewStateModel)
    }
    
    final class Coordinator: NSObject {
        @ObservedObject var webViewStateModel: WebViewStateModel
        let action: ((_ navigationAction: WebView.NavigationAction) -> Void)?
        
        init(action: ((_ navigationAction: WebView.NavigationAction) -> Void)?,
             webViewStateModel: WebViewStateModel) {
            self.action = action
            self.webViewStateModel = webViewStateModel
        }
        
    }
}

extension WebViewWrapper.Coordinator: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if action == nil {
            decisionHandler(.allow)
        } else {
            action?(.decidePolicy(navigationAction, decisionHandler))
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewStateModel.loading = true
        action?(.didStartProvisionalNavigation(navigation))
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        action?(.didReceiveServerRedirectForProvisionalNavigation(navigation))

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        action?(.didFailProvisionalNavigation(navigation, error))
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        action?(.didCommit(navigation))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        if let title = webView.title {
            webViewStateModel.pageTitle = title
        }
        action?(.didFinish(navigation))
        
//        let css =
//        """
//            body { background-color : #ff0000 }
//            
//        """
//        
//        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
//        
//        webView.evaluateJavaScript(js, completionHandler: nil)
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        action?(.didFail(navigation, error))
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if action == nil  {
            completionHandler(.performDefaultHandling, nil)
        } else {
            action?(.didRecieveAuthChallange(challenge, completionHandler))
        }
        
    }
}
