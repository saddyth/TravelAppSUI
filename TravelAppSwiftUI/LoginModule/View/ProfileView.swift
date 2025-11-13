//
//  ProfileView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 5.11.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        if let user = authViewModel.currentUser {
            List {
                Section("Account Info") {
                    HStack{
                        Image(.placeholder)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 5){
                            Text(user.fullName)
                                .merriweather(type: .bold, size: 18)
                            Text(user.email)
                                .merriweather(type: .regular, size: 12)
                        }
                    }
                }
                Section("Account") {
                    Button {
                        Task {
                            try await authViewModel.signOut()
                        }
                    } label: {
                        SettingsView(imageName: "door.right.hand.open", title: "Sign out", tintColor: .red)
                    }
                    .foregroundStyle(.black)
                    Button {
                        Task {
                            try await authViewModel.deleteAccount()
                        }
                    } label: {
                        SettingsView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        
    }
}

#Preview {
    ProfileView()
}


