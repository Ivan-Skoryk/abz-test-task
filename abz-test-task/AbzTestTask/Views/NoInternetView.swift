//
//  Untitled.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

// View used to inform user that there is no internet connection
struct NoInternetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Image("no-internet")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
        
        Text("There is no internet connection")
            .font(.nunitoSans(size: 20))
            .padding(.top, 16)
        
        Button("Try again") {
            dismiss()
        }
        .buttonStyle(CustomButtonStyle())
        .padding(.top, 16)
    }
}

#Preview {
    NoInternetView()
}
