//
//  Token.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

/// A struct representing an authentication token.
///
/// This struct is used to decode or encode a token received from the server,
/// typically after a successful login or sign-up process. The token is used
/// for authenticating subsequent requests.
///
/// - Properties:
///   - token: The authentication token as a string, which is used for user
///            authorization in API requests.
struct Token: Codable {
    let token: String
}
