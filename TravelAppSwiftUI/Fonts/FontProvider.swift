//
//  FontProvider.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 7.10.2025.
//

import Foundation
import SwiftUI

enum Merriweather: String {
    case regular = "Merriweather-Regular"
    case bold = "Merriweather-Bold"
    case black = "Merriweather-Black"
}

enum SourceSans3: String {
    case regular = "SourceSans3-Roman_Regular"
    case bold = "SourceSans3-Roman_Bold"
    case semiBold = "SourceSans3-Roman_SemiBold"
}

extension View {
    func merriweather(type: Merriweather, size: CGFloat = 16) -> some View {
        self
            .font(Font.custom(type.rawValue, size: size))
    }
    
    func sourceSans3(type: SourceSans3, size: CGFloat = 16) -> some View {
        self
            .font(Font.custom(type.rawValue, size: size))
    }
}
