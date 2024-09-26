//
//  CustomActivityIndicator.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI

struct CustomActivityIndicator: View {
    @State private var isAnimating = false
    
    private var animation: Animation {
        Animation.linear(duration: 1.5)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Image(systemName: "progress.indicator")
            .resizable()
            .frame(width: 20, height: 20)
            .rotationEffect(Angle(degrees: isAnimating ? 359 : 0))
            .animation(animation, value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}
