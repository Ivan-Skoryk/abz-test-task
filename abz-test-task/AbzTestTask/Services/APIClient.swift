//
//  APIClient.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidResponse
    case invalidData
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) async -> Result<T, Error>
}

class BaseAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T: Decodable>(_ endpoint: EndpointType) async -> Result<T, Error> {
        var url = endpoint.baseURL.appending(component: endpoint.path)
        
        if let queryItems = endpoint.queryItems {
            url.append(queryItems: queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let params = endpoint.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, 200..<500 ~= response.statusCode else {
                return .failure(APIError.invalidResponse)
            }
            
            guard let data = try? JSONDecoder().decode(T.self, from: data) else {
                return .failure(APIError.invalidData)
            }
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func multipartRequest<T: Decodable>(_ endpoint: EndpointType) async -> Result<T, Error> {
        var url = endpoint.baseURL.appending(component: endpoint.path)
        
        if let queryItems = endpoint.queryItems {
            url.append(queryItems: queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        for (key, value) in endpoint.parameters ?? [:] {
            httpBody.appendString(convertFromField(named: key, value: value, using: boundary))
        }
        
        httpBody.append(
            convertFromFile(
                fieldName: "photo",
                fileName: "photo.jpg",
                mimeType: "image/jpeg",
                fileData: endpoint.imageData ?? Data(),
                using: boundary)
        )
        
        httpBody.appendString("--\(boundary)--\r\n")
        
        request.httpBody = httpBody
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, 200..<500 ~= response.statusCode else {
                return .failure(APIError.invalidResponse)
            }
            
            guard let data = try? JSONDecoder().decode(T.self, from: data) else {
                return .failure(APIError.invalidData)
            }
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func convertFromField(named name: String, value: Any, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    func convertFromFile(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data
    }
}
