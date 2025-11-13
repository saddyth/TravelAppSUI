//
//  Product.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 9.10.2025.
//

import Foundation
import SwiftUI


struct Product: Identifiable, Hashable {

    var id: UUID
    var image: UIImage
    var title: String
    var rating: Int
    var place: String
    var description: String
    var price: Int
    var isLiked: Bool
    var filterApi: String
    var imageURL: URL?
    var category: [Category]
    
  
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
