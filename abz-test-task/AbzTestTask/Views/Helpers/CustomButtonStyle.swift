//
//  CustomButtonStyle.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(configuration.isPressed ? .appButtonPressed : .appButton)
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .animation(.default, value: configuration.isPressed)
    }
}
