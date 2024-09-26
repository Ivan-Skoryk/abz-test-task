//
//  SignUpService.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

/// A protocol defining the sign-up service functionalities.
protocol SignUpServiceProtocol {
    func postUser(token: String, dto: SignUpDTO) async -> Result<SignUpResponse, Error>
    func getPositions() async -> Result<PositionsList, Error>
    func getToken() async -> Result<Token, Error>
}

/// A service class responsible for handling sign-up related API operations.
///
/// This class implements the SignUpServiceProtocol and uses an API client for making network requests.
class SignUpService: SignUpServiceProtocol {
    private let apiClient = BaseAPIClient<SignUpEndpoint>()
    
    /// Posts user data to the API using a token and sign-up DTO.
    /// - Parameters:
    ///   - token: The authorization token for the request.
    ///   - dto: The sign-up data transfer object containing user details.
    func postUser(token: String, dto: SignUpDTO) async -> Result<SignUpResponse, Error> {
        return await apiClient.multipartRequest(.postUser(token: token, user: dto))
    }
    
    /// Retrieves the list of positions from the API.
    func getPositions() async -> Result<PositionsList, Error> {
        return await apiClient.request(.getPositions)
    }
    
    /// Retrieves the token required for user registration.
    func getToken() async -> Result<Token, Error> {
        return await apiClient.request(.getToken)
    }
}
