//
//  UsersEndpoint.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

enum UsersEndpoint: APIEndpoint {
    case getUsers(page: Int)
    
    var path: String {
        switch self {
        case .getUsers: return "users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers: return .get
        }
    }
    
    var queryItems: [String : Any]? {
        switch self {
        case .getUsers(let page):
            return [
                "page": page,
                "count": 6
            ]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getUsers: return nil
        }
    }
    
    var headers: [String : String]? {
        ["accept": "application/json"]
    }
}
