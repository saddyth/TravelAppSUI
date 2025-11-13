//
//  InputView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 5.11.2025.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .merriweather(type: .regular, size: 16)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .sourceSans3(type: .regular, size: 14)
            } else {
                TextField(placeholder, text: $text)
                    .sourceSans3(type: .regular, size: 14)
            }
            
            Divider()
            
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "E-mail", placeholder: "@example.com")
}
