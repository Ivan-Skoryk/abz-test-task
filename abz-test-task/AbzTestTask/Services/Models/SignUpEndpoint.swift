//
//  SignUpEndpoint.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

enum SignUpEndpoint: APIEndpoint {
    case postUser(token: String, user: SignUpDTO)
    case getToken
    case getPositions
    
    var path: String {
        switch self {
        case .getToken: return "token"
        case .postUser: return "users"
        case .getPositions: return "positions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getToken, .getPositions: return .get
        case .postUser: return .post
        }
    }
    
    var queryItems: [String : Any]? {
        switch self {
        case .getToken, .postUser, .getPositions: return nil
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .postUser(_, let user):
            return [
                "name": user.name,
                "email": user.email,
                "phone": user.phone,
                "position_id": user.positionID
            ]
        case .getToken, .getPositions: return nil
        }
    }
    
    var headers: [String : String]? {
        var base = ["accept": "application/json"]
        
        switch self {
        case .postUser(let token, _):
            base["Token"] = token
        case .getToken, .getPositions: break
        }
        
        return base
    }
    
    var imageData: Data? {
        switch self {
        case .postUser(_, let user):
            return user.photoData
        case .getToken, .getPositions: return nil
        }
    }
}
