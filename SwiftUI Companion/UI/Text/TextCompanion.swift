//
//  TextCompanion.swift
//  SwiftUI Companion
//
//  Created by Jerry Hanks on 02/07/2020.
//  Copyright © 2020 Jerry Okafor. All rights reserved.
//

import SwiftUI
import Ink

struct TextCompanion : View {
    @State private var showModal = false
    
    
    var body: some View{
        return ZStack(alignment: .center){
            Button(action: {
                self.showModal = true
            }) {
                 Text("Text Is here!")
            }.sheet(isPresented: self.$showModal) {
                AnotherView().navigationBarTitle("Text Companion")
            }
        }.navigationBarTitle("Text Companion")
    }
}


struct AnotherView : View {
    
//    @Environment(\.presentationMode) var presentationMode

//    self.presentationMode.wrappedValue.dismiss()
    
    @ObservedObject var webViewStateModel = WebViewStateModel()
    var body: some View{
        
        let markdown: String =
        """
            # MemeMe
            Meme is an app that creates memes from images.

            Meme is part of my Udacity iOS Developer Nanodegree program.

            ## Description

            Part 1 : An app that enables the user to take a picture, add text to form a meme, and share the meme with friends.

            Part 2 : Final version of the MemeMe App. Memes will appear in a tab view with two tabs: a table view and a collection view.

            ## Focus
            1. MVC - Model View Controller
            2. Delegate Pattern
            3. Interfaces and UI touch action events
            4. ViewControllers and Multi Veiw layout

            ## Requirements
            XCode >= 10.3

            ```
            struct ContentView: View {
                @ObservedObject var webViewStateModel: WebViewStateModel = WebViewStateModel()
                var body: some View {
                    
                    NavigationView {
                        LoadingView(isShowing: .constant(webViewStateModel.loading)) { //loading logic taken from https://stackoverflow.com/a/56496896/9838937
                            //Add onNavigationAction if callback needed
                            WebView(url: URL.init(string: "https://www.google.com")!, webViewStateModel: self.webViewStateModel)
                        }
                        .navigationBarTitle(Text(webViewStateModel.pageTitle), displayMode: .inline)
                        .navigationBarItems(trailing:
                            Button("Last Page") {
                                self.webViewStateModel.goBack.toggle()
                            }.disabled(!webViewStateModel.canGoBack)
                        )
                    
                 }
                    
                }
            }
        
        ```
        """
        let parser = MarkdownParser()
        var html = parser.html(from: markdown)
            .replacingOccurrences(of: "<pre>", with: "<pre class=\"prettyprint\">")
//            .replacingOccurrences(of: "<code>", with: "<code class=\"language-swift\">")
        
        
        return ZStack{
            LoadingView(isShowing: .constant(webViewStateModel.loading)) { //loading logic taken from https://stackoverflow.com/a/56496896/9838937
                //Add onNavigationAction if callback needed
                WebView(htmlString:html.wrap(title: "Test Html"), webViewStateModel: self.webViewStateModel)
            }
            .navigationBarTitle(Text(webViewStateModel.pageTitle), displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Last Page") {
                    self.webViewStateModel.goBack.toggle()
                }.disabled(!webViewStateModel.canGoBack)
            )
        }
        .navigationBarTitle("Another View")
    }
}


extension String{
    mutating func wrap(title:String) -> String{
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>\(title)</title>
            <script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>
        </head>
        <body>
            \(self)
        
        <style>
            pre {
                background: #f4f4f4 !important;
                border: 1px solid #ddd !important;
                border-left: 3px solid #f36d33 !important;
                border-radius: 10px !important;
                color: #666 !important;
                page-break-inside: avoid !important;
                font-family: monospace !important;
                font-size: 15px !important;
                line-height: 1.6 !important;
                margin-bottom: 1.6em !important;
                overflow: auto !important;
                padding: 1em 1.5em !important;
                display: block !important;
            }
        </style>
        </body>
        
        </html>
        """
    }
}
