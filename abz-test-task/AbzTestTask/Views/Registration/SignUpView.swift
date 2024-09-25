//
//  SignUpView.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

struct Position: Identifiable {
    var id: Int
    var title: String
}

struct SignUpView: View {
    @State var name = ""
    @State var nameValidation = ""
    @State var email = ""
    @State var emailValidation = ""
    @State var phone = ""
    @State var phoneValidation = ""
    @State var photoValidation = "123"
    
    @State var positions: [Position] = [
        Position(id: 0, title: "one"),
        Position(id: 1, title: "two"),
        Position(id: 2, title: "three"),
        Position(id: 3, title: "four"),
    ]
    
    @State var selectedPosition = 0
    
    @State var showSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // header view
            Text("Working with POST request")
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(.appYellow)
            
            // main body
            ScrollView {
                // input text section
                CustomTextInputField(title: "Your name", text: $name, validation: $nameValidation)
                CustomTextInputField(title: "Email", text: $email, validation: $emailValidation)
                CustomTextInputField(title: "Phone", text: $phone, validation: $phoneValidation, supportingText: "+380 (XXX) XXX-XX-XX")
                
                // position selection section
                Text("Select your position")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                
                // radio buttons
                ForEach(positions) { position in
                    HStack() {
                        Button {
                            selectedPosition = position.id
                        } label: {
                            if selectedPosition == position.id {
                                ZStack(alignment: .center) {
                                    Circle()
                                        .foregroundStyle(.appBlue)
                                        .frame(maxWidth: 14, maxHeight: 14)
                                    Circle()
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: 6, maxHeight: 6)
                                }
                                .frame(width: 48, height: 48)
                            } else {
                                ZStack {
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(maxWidth: 14, maxHeight: 14)
                                }
                                .frame(width: 48, height: 48)
                            }
                        }
                        .buttonStyle(CustomRadioButtonStyle())
                        .frame(minWidth: 48)
                        
                        Text(position.title)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                // upload photo section
                ZStack {
                    Text(photoValidation)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(y: 40)
                        .font(.system(size: 16))
                        .foregroundColor(photoValidation.isEmpty ? .secondary : Color.appErrorRed)
                    
                    HStack {
                        Text("Upload photo")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Update")
                                .foregroundStyle(.appBlue)
                        }
                    }
                }
                .font(.system(size: 24))
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: 56)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(photoValidation.isEmpty ? .secondary : Color.appErrorRed, lineWidth: 1)
                }
                .padding(16)
                
                // Sign Up button
                Button("Sign Up") {
                    showSheet.toggle()
                }
                .buttonStyle(CustomButtonStyle())
                .fullScreenCover(isPresented: $showSheet, onDismiss: { showSheet = false }) {
                    NoInternetView()
                }
                .padding(16)
            }
        }
    }
}



#Preview {
    SignUpView()
}


