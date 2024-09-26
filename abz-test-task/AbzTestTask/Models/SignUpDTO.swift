//
//  SignUpDTO.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

/// A data transfer object used for user sign-up.
///
/// This struct packages all the necessary information required to sign up a user,
/// including personal details and a profile photo, to be sent over a network or passed
/// between layers in an application.
///
/// - Properties:
///   - name: The full name of the user.
///   - email: The email address of the user.
///   - phone: The phone number of the user.
///   - positionID: The ID of the position or job role the user is applying for or holds.
///   - photoData: The user's profile photo represented as raw data (e.g., image data).
struct SignUpDTO {
    let name: String
    let email: String
    let phone: String
    let positionID: Int
    let photoData: Data
}
