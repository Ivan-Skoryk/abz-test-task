//
//  CustomTextInputField.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 24.09.2024.
//

import SwiftUI

struct CustomTextInputField: View {
    var title: String
    var supportingText: String
    @Binding var text: String
    @Binding var validation: String
    
    @FocusState private var isFocused: Bool?
    private var keyboardType: UIKeyboardType = .default
    
    init(
        title: String,
        text: Binding<String>,
        validation: Binding<String>,
        supportingText: String = "",
        keyboardType: UIKeyboardType = .default
    ) {
        self.title = title
        self._text = text
        self._validation = validation
        self.supportingText = supportingText
        self.keyboardType = keyboardType
    }
    
    private var titleColor: Color {
        validation.isEmpty ?
        isFocused != nil && text.isEmpty ? .appBlue : .secondary :
        .appErrorRed
    }
    
    private var borderColor: Color {
        validation.isEmpty ?
        isFocused != nil ? Color.appBlue : .secondary :
        .appErrorRed
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Title and placeholder
            Text(title)
                .font(.nunitoSans(size: 20))
                .foregroundColor(titleColor)
                .offset(y: isFocused == nil && text.isEmpty ? 0 : -25)
                .scaleEffect(isFocused == nil && text.isEmpty ? 1 : 0.66, anchor: .leading)
            
            //Supporting text and validation errors
            Text(validation.isEmpty ? supportingText : validation)
                .offset(y: 40)
                .font(.nunitoSans(size: 14))
                .foregroundColor(validation.isEmpty ? .secondary : Color.appErrorRed)
            
            //Textfield
            TextField("", text: $text)
                .textFieldStyle(.plain)
                .keyboardType(keyboardType)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .frame(height: 56)
                .font(.nunitoSans(size: 20))
                .baselineOffset(-6)
                .focused($isFocused, equals: true)
        }
        .padding(.horizontal, 16)
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(borderColor,lineWidth: 1)
        }
        .animation(.default, value: text)
        .animation(.default, value: isFocused)
        .padding(16)
    }
}
