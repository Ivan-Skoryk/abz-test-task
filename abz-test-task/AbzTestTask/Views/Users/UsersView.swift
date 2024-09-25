//
//  UsersView.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case photoURL = "photo"
    }
}

struct UsersView: View {
    
    @State var isEmpty = false
    
    var users: [User] = [
        User(id: 1,name: "User1", email: "email1@example.com", phone: "+3801112223341", position: "Sr.Ebla1", photoURL: ""),
        User(id: 2,name: "User2", email: "email2@example.com", phone: "+3801112223342", position: "Sr.Ebla2", photoURL: ""),
        User(id: 3,name: "User3", email: "email3@example.com", phone: "+3801112223343", position: "Sr.Ebla3", photoURL: ""),
        User(id: 4,name: "User4", email: "email4@example.com", phone: "+3801112223344", position: "Sr.Ebla4", photoURL: ""),
        User(id: 5,name: "User5", email: "email5@example.com", phone: "+3801112223345", position: "Sr.Ebla5", photoURL: ""),
        User(id: 6,name: "User6", email: "email6@example.com", phone: "+3801112223346", position: "Sr.Ebla6", photoURL: ""),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Working with GET request")
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(.appYellow)
            
            if !isEmpty {
                List(users) { user in
                    HStack(alignment: .top, spacing: 16) {
                        Circle()
                            .fill(.gray.opacity(0.3))
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
                .listStyle(.plain)
            } else {
                Spacer()
                
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
                
                Text("There are no users yet")
                    .font(.system(size: 24))
                    .padding(16)
                
                Spacer()
            }
        }
    }
}

#Preview {
    UsersView()
}
