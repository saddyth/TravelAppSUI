//
//  RatingView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 16.10.2025.
//

import SwiftUI

struct RatingView: View {
    @Bindable var discoverVM: DiscoverViewModel
    @Binding var product: Product
    var textColor: Color
    var body: some View {
        HStack(spacing: 3) {
            ForEach(1..<6) { index in
                Image(Int(product.rating) >= index ? .starfill : .starEmpty)
                    .resizable()
                    .frame(width: 10, height: 9)
                    .onTapGesture {
                        discoverVM.updateStars(for: product, to: Int(index))
                    }
            }
            Text("\(product.rating)")
                .sourceSans3(type: .bold, size: 13)
                .foregroundStyle(textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
