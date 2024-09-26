//
//  PositionsList.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

/// A model used in response for positions request
struct PositionsList: Codable {
    /// An array of `Position` objects representing the list of positions.
    let positions: [Position]
}

/// A model representing a position, conforming to `Identifiable` and `Codable`.
///
/// Each `Position` has a unique `id`, which makes it identifiable in SwiftUI
/// lists or collections, and it can be easily encoded and decoded for networking
/// or persistence purposes.
///
/// - Properties:
///   - id: A unique identifier for the position.
///   - name: The name of the position.
struct Position: Identifiable, Codable {
    let id: Int
    let name: String
}
