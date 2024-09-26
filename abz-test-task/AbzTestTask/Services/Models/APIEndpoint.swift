//
//  APIEndpoint.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: Any]? { get }
    var parameters: [String: Any]? { get }
    var imageData: Data? { get }
    var headers: [String: String]? { get }
}

extension APIEndpoint {
    var baseURL: URL {
        return URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/")!
    }
    
    var imageData: Data? {
        nil
    }
}
