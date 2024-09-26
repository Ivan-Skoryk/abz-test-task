//
//  CustomRadioButtonStyle.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import SwiftUI

/// A custom radio button style that adjusts appearance based on the button state.
struct CustomRadioButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? .appBlue.opacity(0.1) : .clear)
            .clipShape(Circle())
            .animation(.default, value: configuration.isPressed)
    }
}
