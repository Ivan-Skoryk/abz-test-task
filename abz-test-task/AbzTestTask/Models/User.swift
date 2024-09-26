//
//  User.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import Foundation

/// A struct representing a user.
///
/// This struct contains information about a user, including their unique identifier,
/// contact details, position, and profile photo URL. It conforms to `Identifiable`
/// for use in SwiftUI lists and `Codable` for easy encoding/decoding with JSON.
///
/// - Properties:
///   - id: A unique identifier for the user.
///   - name: The user's full name.
///   - email: The user's email address.
///   - phone: The user's phone number.
///   - position: The user's job position or title.
///   - photoURL: A URL string pointing to the user's profile photo.
struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case photoURL = "photo"
    }
}

/// A struct representing a paginated list of users.
///
/// This struct is used to decode a list of users returned from an API,
/// including pagination information such as the total number of pages.
///
/// - Properties:
///   - totalPages: The total number of pages available in the user list.
///   - users: An array of `User` objects representing the list of users.
struct UsersList: Codable {
    let totalPages: Int
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case users
    }
}
