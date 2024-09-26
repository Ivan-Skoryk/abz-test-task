//
//  CustomButtonStyle.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import SwiftUI

/// A custom button style that adjusts appearance based on the button state.
struct CustomButtonStyle: ButtonStyle {
    var disabled = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 140, height: 48)
            .background(
                disabled ?
                    .appButtonDisabled :
                    configuration.isPressed ? .appButtonPressed : .appButton
            )
            .foregroundStyle(.black)
            .font(.nunitoSans(size: 18))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .animation(.default, value: configuration.isPressed)
    }
}
