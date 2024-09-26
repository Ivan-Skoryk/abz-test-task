//
//  APIEndpoint.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

/// A protocol defining the requirements for an API endpoint.
///
/// This protocol includes properties for the base URL, endpoint path, HTTP method,
/// query items, body parameters, image data, and headers. Any type conforming to this
/// protocol must implement these properties to effectively describe an API endpoint.
protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: Any]? { get }
    var parameters: [String: Any]? { get }
    var imageData: Data? { get }
    var headers: [String: String]? { get }
}

/// Extension with a default implementation of APIEndpoint variables
extension APIEndpoint {
    var baseURL: URL {
        return URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/")!
    }
    
    var imageData: Data? {
        nil
    }
}
