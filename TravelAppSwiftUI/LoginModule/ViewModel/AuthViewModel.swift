//
//  AuthViewModel.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 7.11.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import _PhotosUI_SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorMessage: String?
  
    var likesStorage: LikeStorage = .shared
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            errorMessage = nil
            self.userSession = result.user
            await fetchUser()
            await likesStorage.fetchLikes()
            NotificationCenter.default.post(name: Notification.Name("signIn"), object: nil)
        } catch {
            if let error = error as? NSError, let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .invalidCredential:
                    errorMessage = "Wrong password or email"
                default:
                    print("Unable to sign in with \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            await likesStorage.fetchLikes()
        } catch {
            if let error = error as? NSError, let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .emailAlreadyInUse:
                    errorMessage = "Email is already in use"
                default:
                    print("Failed to create user  \(error.localizedDescription)")
                }
            }
        }
    }
    
    func signOut() async throws{
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            Task { @MainActor in
                likesStorage.likedProductsIDs.removeAll()
            }
            NotificationCenter.default.post(name: Notification.Name("signOut"), object: nil)
        } catch {
            print("Failed to sign out \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {return}
        do {
            try await user.delete()
            self.userSession = nil
            likesStorage.likedProductsIDs.removeAll()
        } catch {
            print("Failed to delete account \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
