//
//  Untitled.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

struct NoInternetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Image(systemName: "wifi.slash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
        
        Text("There is no internet connection")
        
        Button {
            dismiss()
        } label: {
            Text("Try again")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.yellow)
        .cornerRadius(20)
    }
}

#Preview {
    NoInternetView()
}
