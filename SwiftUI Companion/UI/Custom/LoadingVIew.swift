//
//  LoadingVIew.swift
//  SwiftUI Companion
//
//  Created by Jerry Hanks on 03/07/2020.
//  Copyright © 2020 Jerry Okafor. All rights reserved.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack(alignment: .center, spacing: 8) {
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                    Text("Loading...")
                }
                .frame(width: geometry.size.width / 3,
                       height: geometry.size.width / 3)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(10)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
