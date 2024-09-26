//
//  SignUpFinish.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI

struct SignUpFinish: View {
    @Environment(\.dismiss) var dismiss
    var success = true
    var message = ""

    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "xmark")
                .resizable()
                .foregroundStyle(.secondary)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 30, alignment: .trailing)
                .padding(.bottom, 48)
            
            Spacer()
            
            Image(success ? "post-success" : "post-failure")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200, maxHeight: 200)
            
            Text(message)
                .font(.nunitoSans(size: 20))
                .padding(.top, 16)
            
            Button(success ? "Got it" : "Try again") {
                dismiss()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(32)
    }
}

#Preview {
    SignUpFinish(success: true, message: "Hello")
}
