//
//  SettingsView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 5.11.2025.
//

import SwiftUI

struct SettingsView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: imageName)
                .foregroundStyle(tintColor)
            
            Text(title)
                .merriweather(type: .regular, size: 14)
        }
    }
}

#Preview {
    SettingsView(imageName: "door.right.hand.open", title: "Sign Out", tintColor: .red)
}
