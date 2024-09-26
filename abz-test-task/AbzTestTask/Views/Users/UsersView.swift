//
//  UsersView.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

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
            .font(.nunitoSans(size: 20))
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(user.name)
                            .font(.nunitoSans(size: 18))
                            .padding(.bottom, 4)
                        
                        Text(user.position)
                            .foregroundColor(.gray)
                            .padding(.bottom, 8)
                        
                        Text(user.email)
                        Text(user.phone)
                    }
                    .font(.nunitoSans(size: 14))
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
                    Image("no-users")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.appBlue)
                    
                }
                .frame(maxWidth: 300)
                .padding(.top, 120)
                
                Text("There are no users yet")
                    .font(.nunitoSans(size: 20))
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
