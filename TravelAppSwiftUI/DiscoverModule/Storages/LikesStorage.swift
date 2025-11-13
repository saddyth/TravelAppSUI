//
//  LikesStorage.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 3.11.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


@Observable

final class LikeStorage {
    static let shared = LikeStorage(); private init() {}
    var likedProductsIDs: Set<String> = []
    
    func toggleLike(for product: Product) async {
        do{
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let user = Firestore.firestore().collection("users").document(uid)
            let liked = user.collection("likes").document(product.id.uuidString)
            
            if likedProductsIDs.contains(product.id.uuidString) {
                try await liked.delete()
                likedProductsIDs.remove(product.id.uuidString)
            } else {
                try await liked.setData([product.id.uuidString: true])
                likedProductsIDs.insert(product.id.uuidString)
            }
        } catch {
            print("Unable to toggle like \(error.localizedDescription)")
        }
    }
    
    func isLiked(id: UUID) -> Bool {
        return likedProductsIDs.contains(id.uuidString)
    }
    
    func fetchLikes() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        do {
            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).collection("likes").getDocuments()
            else {return}
            let ids = snapshot.documents.map { $0.documentID}
            
            likedProductsIDs = Set(ids)
        }
    }
}
