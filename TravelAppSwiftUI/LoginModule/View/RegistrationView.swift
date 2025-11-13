//
//  RegistrationView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 5.11.2025.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30){
                Text("Sign up")
                    .merriweather(type: .bold, size: 24)
                VStack(alignment: .leading){
                    InputView(text: $email, title: "E-mail", placeholder: "fff@example.com")
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $name, title: "Full Name", placeholder: "Enter your name")
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Enter your password", isSecureField: true)
                        .textInputAutocapitalization(.never)
                    HStack{
                        if let errorMessage = authViewModel.errorMessage {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundStyle(.red)
                            Text(errorMessage)
                                .merriweather(type: .regular, size: 10)
                                .foregroundStyle(.red)
                        }
                    }
                }
                Button(action: {
                    Task {
                        try await authViewModel.createUser(withEmail: email, password: password, fullname: name)
                    }
                }, label: {
                    Text("Sign up")
                        .merriweather(type: .regular, size: 16)
                        .foregroundStyle(.white)
                        .frame(width: geo.size.width * 0.5, height: 50)
                })
                .background(.main)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                HStack{
                    Text("Already have an accound?")
                        .merriweather(type: .regular, size: 12)
                    Text("Sign in")
                        .merriweather(type: .bold, size: 12)
                }
                .onTapGesture {
                    dismiss()
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .navigationBarBackButtonHidden(true)
    }
}
extension RegistrationView {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !email.isEmpty
    }
}

#Preview {
    RegistrationView()
}
