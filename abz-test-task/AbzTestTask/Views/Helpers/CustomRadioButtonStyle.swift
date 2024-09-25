//
//  CustomRadioButtonStyle.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import SwiftUI

struct CustomRadioButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? .appBlue.opacity(0.1) : .clear)
            .clipShape(Circle())
            .animation(.default, value: configuration.isPressed)
    }
}
