//
//  SpinningView.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/17.
//

import SwiftUI

struct SpinningView: ViewModifier {
    @State var isVisible: Bool = false
    
    func body(content: Content) -> some View {
        content.rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear { self.isVisible = true }
    }
}

extension View {
    func spinning() -> some View {
        self.modifier(SpinningView())
    }
}
