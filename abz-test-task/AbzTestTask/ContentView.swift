//
//  ContentView.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var monitor = NetworkMonitor()
    
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            tabView
            
            tabbar
        }
        .background(.appBackground)
        .fullScreenCover(isPresented: $monitor.isDisconnected, onDismiss: { monitor.checkConnection() }) {
            NoInternetView()
        }
    }
    
    private var tabView: some View {
        TabView(selection: $selectedTab) {
            UsersView()
                .tag(0)
            
            SignUpView()
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .toolbarBackground(.hidden, for: .tabBar)
    }
    
    private var tabbar: some View {
        ZStack {
            HStack {
                ForEach(Tabs.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab.rawValue
                    } label: {
                        customTabView(icon: tab.iconName, title: tab.title, isActive: selectedTab == tab.rawValue)
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color.appTabBarBackground)
    }
    
    private func customTabView(icon: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            
            Image(systemName: icon)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .foregroundColor(isActive ? .appBlue: .black.opacity(0.6))
            
            Text(title)
                .font(.nunitoSans(size: 16))
                .foregroundColor(isActive ? .mint: .gray)
            
            Spacer()
        }
        .animation(.default, value: isActive)
    }
}

enum Tabs: Int, CaseIterable {
    case users = 0
    case signUp = 1
    
    var title: String {
        switch self {
        case .users: return "Users"
        case .signUp: return "Sign up"
        }
    }
    
    var iconName: String {
        switch self {
        case .users: return "person.3.sequence.fill"
        case .signUp: return "person.crop.circle.fill.badge.plus"
        }
    }
}

#Preview {
    ContentView()
}
