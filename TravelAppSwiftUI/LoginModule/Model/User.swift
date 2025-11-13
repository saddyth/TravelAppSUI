//
//  User.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 7.11.2025.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
}

extension User{
    static var MOCK_USER = User(id: NSUUID().uuidString, fullName: "Bob bob", email: "ffkdf@mail.ru")
}
