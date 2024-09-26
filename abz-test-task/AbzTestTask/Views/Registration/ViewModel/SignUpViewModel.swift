//
//  SignUpViewModel.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    private let signUpService = SignUpService()
    
    @Published var name = ""
    @Published var nameValidation = ""
    @Published var email = ""
    @Published var emailValidation = ""
    @Published var phone = ""
    @Published var phoneValidation = ""
    
    @Published var photoData: Data?
    @Published var photoValidation = ""
    
    @Published var positions: [Position] = []
    
    @Published var selectedPosition = 1
    
    @Published var showSheet = false
    var postSuccess = false
    var postMessage = ""
    
    var isButtonDisabled: Bool {
        name.isEmpty && email.isEmpty && phone.isEmpty && photoData != nil
    }
    
    // Function to fetch available positions
    func fetchPositions() async {
        let result = await signUpService.getPositions()
        
        switch result {
        case .success(let list):
            DispatchQueue.main.async {
                self.positions = list.positions
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private var token = ""
    // Function to get user token
    func getToken() async {
        let result = await signUpService.getToken()
        switch result {
        case .success(let token):
            self.token = token.token
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    // Function to post user data
    func postUser() async {
        guard validate() else { return }
        
        let signUpDTO = SignUpDTO(
            name: self.name,
            email: self.email,
            phone: self.phone,
            positionID: self.selectedPosition,
            photoData: self.photoData ?? Data()
        )
        
        let result = await signUpService.postUser(token: token, dto: signUpDTO)
        
        switch result {
        case .success(let response):
            guard response.fails != nil else {
                DispatchQueue.main.async {
                    self.postSuccess = response.success
                    self.postMessage = response.message
                    self.showSheet.toggle()
                    
                    if response.success {
                        self.clearData()
                    }
                }
                return
            }
            
            for fail in Fail.allCases {
                DispatchQueue.main.async {
                    let validationString = response.fails?[fail.rawValue]?.compactMap{ $0 }.joined(separator: "\n") ?? ""
                    switch fail {
                    case .name: self.nameValidation = validationString
                    case .email: self.emailValidation = validationString
                    case .phone: self.phoneValidation = validationString
                    case .photo: self.photoValidation = validationString
                    default: break
                    }
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    // Function to validate user input
    private func validate() -> Bool {
        var isValidForm = true
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isValidForm = false
            nameValidation = "Required field"
        }
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isValidForm = false
            emailValidation = "Required field"
        }
        
        if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isValidForm = false
            phoneValidation = "Required field"
        }
        
        if photoData == nil {
            isValidForm = false
            photoValidation = "Photo is required"
        }
        
        return isValidForm
    }
    
    // Function to clear user input data
    func clearData() {
        name = ""
        email = ""
        phone = ""
        photoData = Data()
        selectedPosition = 1
    }
    
    // Function to clear validation messages
    func clearValidation() {
        nameValidation = ""
        emailValidation = ""
        phoneValidation = ""
        photoValidation = ""
    }
}
