//
//  LoginView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 5.11.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var path: [Screen]
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30){
                Text("Log in")
                    .merriweather(type: .bold, size: 24)
                VStack(alignment: .leading){
                    InputView(text: $email, title: "E-mail", placeholder: "fff@example.com")
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
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
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
                }, label: {
                    Text("Sign in")
                        .merriweather(type: .regular, size: 16)
                        .foregroundStyle(.white)
                        .frame(width: geo.size.width * 0.5, height: 50)
                })
                .background(.main)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                HStack{
                    Text("Don't have an account?")
                        .merriweather(type: .regular, size: 12)
                    Text("Sign up")
                        .merriweather(type: .bold, size: 12)
                }
                .onTapGesture {
                    path.append(.registration)
                }
                
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}

extension LoginView {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}

#Preview {
    LoginView(path: .constant([]))
}
