//
//  UsersService.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import Foundation

/// A protocol defining the user service functionalities.
protocol UsersServiceProtocol {
    func getUsers(page: Int) async -> Result<UsersList, Error>
}

/// A service class responsible for handling user-related API operations.
///
/// This class implements the UsersServiceProtocol and uses an API client for making network requests.
class UsersService: UsersServiceProtocol {
    private let apiClient = BaseAPIClient<UsersEndpoint>()
    
    /// Fetches a list of users from the API for a specified page.
    /// - Parameter page: The page number to retrieve users from.
    func getUsers(page: Int) async -> Result<UsersList, Error> {
        return await apiClient.request(.getUsers(page: page))
    }
}
