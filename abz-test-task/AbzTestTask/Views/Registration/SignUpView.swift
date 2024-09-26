//
//  SignUpView.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    @State private var showPhotoOptions = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView {
                textInputSection
                positionSelectionSection
                uploadPhotoSection
                signUpButtonSection
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .task {
            await viewModel.fetchPositions()
            await viewModel.getToken()
        }
        .fullScreenCover(isPresented: $viewModel.showSheet) {
            SignUpFinish(success: viewModel.postSuccess, message: viewModel.postMessage)
        }
    }
    
    private var header: some View {
            Text("Working with POST request")
                .font(.nunitoSans(size: 20))
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(.appYellow)
    }
    
    private var textInputSection: some View {
        VStack(spacing: 0) {
            CustomTextInputField(title: "Your name", text: $viewModel.name, validation: $viewModel.nameValidation)
            CustomTextInputField(title: "Email", text: $viewModel.email, validation: $viewModel.emailValidation ,keyboardType: .emailAddress)
            CustomTextInputField(title: "Phone", text: $viewModel.phone, validation: $viewModel.phoneValidation, supportingText: "+38 (XXX) XXX-XX-XX", keyboardType: .phonePad)
        }
        .focused($isFocused)
    }
    
    private var positionSelectionSection: some View {
        VStack(spacing: 0) {
            Text("Select your position")
                .font(.nunitoSans(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            
            // radio buttons
            ForEach(viewModel.positions) { position in
                HStack() {
                    Button {
                        viewModel.selectedPosition = position.id
                    } label: {
                        if viewModel.selectedPosition == position.id {
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
                    
                    Text(position.name)
                        .font(.nunitoSans(size: 16))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
    
    private var uploadPhotoSection: some View {
        VStack(spacing: 0) {
            // upload photo section
            ZStack {
                Text(viewModel.photoValidation)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 40)
                    .font(.nunitoSans(size: 14))
                    .foregroundColor(viewModel.photoValidation.isEmpty ? .secondary : Color.appErrorRed)
                
                HStack {
                    if viewModel.photoData != nil {
                        HStack {
                            Image(systemName: "paperclip")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.secondary)
                            
                            Text("photo.jpg")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Upload your photo")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Button("Update") {
                        showPhotoOptions.toggle()
                    }
                    .foregroundStyle(.appBlue)
                    .confirmationDialog("Choose how you want to add photo", isPresented: $showPhotoOptions, titleVisibility: .visible) {
                        Button("Camera") {
                            self.sourceType = .camera
                            self.showImagePicker.toggle()
                        }
                        
                        Button("Gallery") {
                            self.sourceType = .photoLibrary
                            self.showImagePicker.toggle()
                        }
                    }
                }
            }
            .font(.nunitoSans(size: 20))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 56)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(viewModel.photoValidation.isEmpty ? .secondary : Color.appErrorRed, lineWidth: 1)
            }
            .padding(16)
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImageData: $viewModel.photoData, sourceType: self.sourceType)
            }
        }
    }
    
    private var signUpButtonSection: some View {
        Button("Sign Up") {
            viewModel.clearValidation()
            Task { await viewModel.postUser() }
        }
        .disabled(viewModel.isButtonDisabled)
        .buttonStyle(CustomButtonStyle(disabled: viewModel.isButtonDisabled))
        .padding(16)
    }
}

#Preview {
    SignUpView()
}


