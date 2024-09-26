//
//  Data+Extension.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

extension Data {
    /// Appends the given string to the current data object.
    ///
    /// This method takes a string, converts it to UTF-8 encoded data,
    /// and appends it to the receiver (likely a `Data` object).
    /// If the conversion fails, the append operation does not occur.
    ///
    /// - Parameter string: The `String` to append, encoded as UTF-8 data.
    mutating func appendString(_ string: String) {
        // Convert the string to UTF-8 data
        if let data = string.data(using: .utf8) {
            // Append the resulting data to the current object
            self.append(data)
        }
    }
}
