//
//  UsersViewModel.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI

enum UsersViewModelState {
    case loading
    case moreDataAvailable
    case idle
}

final class UsersViewModel: ObservableObject {
    private let usersService = UsersService()
    
    @Published var state: UsersViewModelState = .idle
    @Published var users: [User] = []
    
    func fetchUsers(refresh: Bool = false) async {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        let page = refresh ? 1 : (users.count / 6) + 1
        let response = await usersService.getUsers(page: page)
        switch response {
        case .success(let list):
            print("users here")
            DispatchQueue.main.async {
                self.state = page < list.totalPages ? .moreDataAvailable : .idle
                if refresh {
                    self.users = list.users
                } else {
                    self.users += list.users
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
            break
        }
    }
    
    func refreshUsers() async {
        await fetchUsers(refresh: true)
    }
}
