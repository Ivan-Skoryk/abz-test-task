//
//  UsersService.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

protocol UsersServiceProtocol {
    func getUsers(page: Int) async -> Result<UsersList, Error>
}

class UsersService: UsersServiceProtocol {
    private let apiClient = BaseAPIClient<UsersEndpoint>()
    
    func getUsers(page: Int) async -> Result<UsersList, any Error> {
        print("waiting in user service")
        return await apiClient.request(.getUsers(page: page))
    }
}
