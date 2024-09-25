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
    
    @FocusState var isFocused: Bool?
    
    init(title: String, text: Binding<String>, validation: Binding<String>, supportingText: String = "") {
        self.title = title
        self._text = text
        self._validation = validation
        self.supportingText = supportingText
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Title and placeholder
            Text(title)
                .font(.system(size: 24))
                .foregroundColor(isFocused != nil && text.isEmpty ? Color.appBlue : .secondary)
                .offset(y: isFocused == nil && text.isEmpty ? 0 : -25)
                .scaleEffect(isFocused == nil && text.isEmpty ? 1 : 0.66, anchor: .leading)
            
            //Supporting text and validation errors
            Text(validation.isEmpty ? supportingText : validation)
                .offset(y: 40)
                .font(.system(size: 16))
                .foregroundColor(validation.isEmpty ? .secondary : Color.appErrorRed)
            
            //Textfield
            TextField("", text: $text)
                .textFieldStyle(.plain)
                .frame(height: 56)
                .font(.system(size: 24))
                .baselineOffset(-6)
                .focused($isFocused, equals: true)
        }
        .padding(.horizontal, 16)
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFocused != nil ? Color.appBlue : .secondary, lineWidth: 1)
        }
        .animation(.default, value: text)
        .animation(.default, value: isFocused)
        .padding(16)
    }
}
