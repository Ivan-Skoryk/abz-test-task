//
//  NetworkManager.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 25.09.2024.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: Any]? { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension APIEndpoint {
    var baseURL: URL {
        return URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/")!
    }
}

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
        
        print("sending request")
        print(request)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print("here is failed response \(response)")
                return .failure(APIError.invalidResponse)
            }
            
            guard let data = try? JSONDecoder().decode(T.self, from: data) else {
                print("failed to decode")
                return .failure(APIError.invalidData)
            }
            
            print("sukes in base api")
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}



struct UsersList: Codable {
    let totalPages: Int
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case users
    }
}

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
                "position_id": user.positionID,
                "photo": user.photoData
            ]
        case .getToken, .getPositions: return nil
        }
    }
    
    var headers: [String : String]? {
        var base = ["accept": "application/json"]
        
        switch self {
        case .postUser(let token, _):
            base["token"] = token
//            base["content-type"] = "multipart/form-data"
        case .getToken, .getPositions: break
        }
        
        return base
    }
}

struct SignUpDTO {
    let name: String
    let email: String
    let phone: String
    let positionID: Int
    let photoData: String
}

protocol SignUpServiceProtocol {
    func postUser()
    func getPosiions()
    func getToken()
}

class SignUpService: SignUpServiceProtocol {
    let apiClient = BaseAPIClient<SignUpEndpoint>()
    
    func postUser() {
        
    }
    
    func getPosiions() {
        
    }
    
    func getToken() {
        
    }
}

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
        var base = ["accept": "application/json"]
        
        switch self {
        case .getUsers: break
        }
        
        return base
    }
}

protocol UsersServiceProtocol {
    func getUsers(page: Int) async -> Result<UsersList, Error>
}

class UsersService: UsersServiceProtocol {
    let apiClient = BaseAPIClient<UsersEndpoint>()
    
    func getUsers(page: Int) async -> Result<UsersList, any Error> {
        print("waiting in user service")
        return await apiClient.request(.getUsers(page: page))
    }
}
