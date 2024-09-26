//
//  SignUpService.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

protocol SignUpServiceProtocol {
    func postUser(token: String, dto: SignUpDTO) async -> Result<SignUpResponse, Error>
    func getPosiions() async -> Result<PositionsList, Error>
    func getToken() async -> Result<Token, Error>
}

class SignUpService: SignUpServiceProtocol {
    private let apiClient = BaseAPIClient<SignUpEndpoint>()
    
    func postUser(token: String, dto: SignUpDTO) async -> Result<SignUpResponse, Error> {
        return await apiClient.multipartRequest(.postUser(token: token, user: dto))
    }
    
    func getPosiions() async -> Result<PositionsList, Error> {
        return await apiClient.request(.getPositions)
    }
    
    func getToken() async -> Result<Token, Error> {
        return await apiClient.request(.getToken)
    }
}
