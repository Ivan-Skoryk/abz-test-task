//
//  APIClient.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import Foundation

/// An enum representing the available HTTP methods.
///
/// Each case corresponds to a standard HTTP method and is represented as a raw string.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// An enum representing potential errors during API requests.
///
/// This enum conforms to Swift's `Error` protocol and can be used to handle
/// specific API-related errors such as invalid responses or data.
enum APIError: Error {
    case invalidResponse
    case invalidData
}

/// A protocol defining the requirements for an API client.
///
/// This protocol includes a method for making requests and requires a type
/// that conforms to the `APIEndpoint` protocol.
protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) async -> Result<T, Error>
    func multipartRequest<T: Decodable>(_ endpoint: EndpointType) async -> Result<T, Error>
}

/// A generic base class for making API requests.
///
/// This class conforms to the `APIClient` protocol and provides implementations
/// for standard requests and multipart requests using async/await.
class BaseAPIClient<EndpointType: APIEndpoint>: APIClient {
    /// Makes a request to the specified API endpoint and decodes the response.
    func request<T: Decodable>(_ endpoint: EndpointType) async -> Result<T, Error> {
        var url = endpoint.baseURL.appending(component: endpoint.path)
        
        // Append query items to the URL if they exist
        if let queryItems = endpoint.queryItems {
            url.append(queryItems: queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers to the request
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Set the HTTP body for POST requests
        if let params = endpoint.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        
        do {
            // Perform the request and await the response
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, 200..<500 ~= response.statusCode else {
                return .failure(APIError.invalidResponse)
            }
            
            // Decode the response data into the expected type
            guard let data = try? JSONDecoder().decode(T.self, from: data) else {
                return .failure(APIError.invalidData)
            }
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    /// Makes a multipart request to the specified API endpoint and decodes the response.
    func multipartRequest<T: Decodable>(_ endpoint: EndpointType) async -> Result<T, Error> {
        var url = endpoint.baseURL.appending(component: endpoint.path)
        
        // Append query items to the URL if they exist
        if let queryItems = endpoint.queryItems {
            url.append(queryItems: queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers to the request
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Unique boundary for multipart
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        
        // Append parameters to the HTTP body
        for (key, value) in endpoint.parameters ?? [:] {
            httpBody.appendString(convertFromField(named: key, value: value, using: boundary))
        }
        
        // Append image data if available
        httpBody.append(
            convertFromFile(
                fieldName: "photo",
                fileName: "photo.jpg",
                mimeType: "image/jpeg",
                fileData: endpoint.imageData ?? Data(),
                using: boundary)
        )
        
        // End of multipart form
        httpBody.appendString("--\(boundary)--\r\n")
        
        request.httpBody = httpBody
        
        do {
            // Perform request and await the response
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, 200..<500 ~= response.statusCode else {
                return .failure(APIError.invalidResponse)
            }
            
            // Decode the response data into the expected type
            guard let data = try? JSONDecoder().decode(T.self, from: data) else {
                return .failure(APIError.invalidData)
            }
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    /// Converts a field into a string representation for multipart form data.
    func convertFromField(named name: String, value: Any, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    /// Converts a file into data representation for multipart form data.
    func convertFromFile(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)  // Append the file data
        data.appendString("\r\n")
        
        return data
    }
}
