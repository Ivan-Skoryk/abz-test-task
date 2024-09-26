//
//  Fail.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

enum Fail: String, CaseIterable {
    case name
    case email
    case phone
    case positionID = "position_id"
    case photo
}

struct SignUpResponse: Codable {
    let success: Bool
    let message: String
    let fails: [String: [String]]?
}
