//
//  PositionsList.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

struct PositionsList: Codable {
    let positions: [Position]
}

struct Position: Identifiable, Codable {
    let id: Int
    let name: String
}
