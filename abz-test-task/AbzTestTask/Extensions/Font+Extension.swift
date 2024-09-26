//
//  Font+Extension.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI

extension Font {
    /// Returns a Nunito Sans font with the specified size.
    ///
    /// This method provides a convenient way to use the "Nunito Sans" font
    /// (specifically the "ExtraLight_Regular" style) in the app. The font name
    /// used must match the name of the font that has been included in the app's
    /// resources and registered in the Info.plist file.
    ///
    /// - Parameter size: The desired font size.
    /// - Returns: A `Font` object with the "Nunito Sans" font at the specified size.
    public static func nunitoSans(size: CGFloat) -> Font {
        // Use the custom Nunito Sans font with the given size
        return Font.custom("NunitoSans-12ptExtraLight_Regular", size: size)
    }
}
