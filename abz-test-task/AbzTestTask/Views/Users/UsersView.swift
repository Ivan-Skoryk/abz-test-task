//
//  UsersView.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
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

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if !viewModel.users.isEmpty {
                usersList
            } else {
                emptyView
            }
        }
    }
    
    private var header: some View {
        Text("Working with GET request")
            .font(.system(size: 24))
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(.appYellow)
    }
    
    private var usersList: some View {
        List {
            ForEach(viewModel.users) { user in
                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: URL(string: user.photoURL)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(user.name)
                            .font(.system(size: 24))
                        Text(user.position)
                            .foregroundColor(.gray)
                        Text(user.email)
                        Text(user.phone)
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                }
            }
            
            switch viewModel.state {
            case .loading:
                CustomActivityIndicator()
                    .frame(maxWidth: .infinity)
            case .moreDataAvailable:
                CustomActivityIndicator()
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        Task { await viewModel.fetchUsers() }
                    }
            case .idle:
                EmptyView()
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshUsers()
        }
    }
    
    private var emptyView: some View {
        List {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .stroke(.black.opacity(0.87), lineWidth: 1)
                    Circle()
                        .foregroundStyle(.appElipseBackground)
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.appBlue)
                    
                }
                .frame(maxWidth: 300)
                .padding(.top, 120)
                
                Text("There are no users yet")
                    .font(.system(size: 24))
                    .padding(16)
            }
            .frame(maxWidth: .infinity)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .task {
            await viewModel.fetchUsers()
        }
        .refreshable {
            await viewModel.refreshUsers()
        }
    }
}

#Preview {
    UsersView()
}
