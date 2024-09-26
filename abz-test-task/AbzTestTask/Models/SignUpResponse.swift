//
//  Fail.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

/// An enum representing possible fields that may fail during the sign-up process.
///
/// The raw values of the cases correspond to the backend's field names,
/// with one case (`positionID`) having a custom raw value.
/// The enum conforms to `CaseIterable`, so all cases can be easily iterated.
///
/// - Cases:
///   - name: The name field failed.
///   - email: The email field failed.
///   - phone: The phone field failed.
///   - positionID: The position ID field failed (custom raw value "position_id").
///   - photo: The photo field failed.
enum Fail: String, CaseIterable {
    case name
    case email
    case phone
    case positionID = "position_id"
    case photo
}

/// A struct representing the response from a sign-up attempt.
///
/// The response includes whether the sign-up was successful, a message, and an optional
/// dictionary of failure details. The dictionary uses field names as keys (e.g., "name", "email")
/// and arrays of error messages as values, describing what went wrong for each field.
///
/// - Properties:
///   - success: A boolean indicating whether the sign-up was successful.
///   - message: A message from the server, typically containing a status or error description.
///   - fails: An optional dictionary of failure messages, where the keys are the field names
///            and the values are arrays of error messages related to that field.
struct SignUpResponse: Codable {
    let success: Bool
    let message: String
    let fails: [String: [String]]?
}
