//
//  User.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//


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