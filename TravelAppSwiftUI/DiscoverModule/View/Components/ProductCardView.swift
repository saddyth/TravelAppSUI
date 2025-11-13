//
//  ProductCardView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 5.11.2025.
//

import SwiftUI
import Kingfisher

struct ProductCardView: View {
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let rectangleHeight: CGFloat
    let titleSize: CGFloat
    @Binding var product: Product
    @Bindable var discoverVM: DiscoverViewModel
    @Binding var path: [Screen]
    let index: Int
    @State var responceCity: ResponceCity.Feature?
    var body: some View {
        ZStack {
            if let imageURL = product.imageURL {
                KFImage(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 19))
            } else {
                Image(.placeholder)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 19))
            }
            VStack {
                ZStack {
                    Rectangle()
                        .frame(width: cardWidth, height: rectangleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 19))
                        .foregroundStyle(.cellRectangle)
                    HStack{
                        VStack(spacing: 3) {
                            Text(product.title)
                                .merriweather(type: .bold, size: titleSize)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            
                            RatingView(discoverVM: discoverVM, product: $product, textColor: .white)
                        }
                        .padding(.horizontal, 22)
                        
                        ZStack{
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                            Button(action: {
                                discoverVM.updateLike(for: product)
                            }, label: {
                                Image(product.isLiked ? .heartfill : .heartempty)
                            })
                        }
                        .frame(maxWidth: 20, alignment: .trailing)
                        .padding(.trailing, 10)
                        .padding(.bottom, rectangleHeight * 0.3)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onTapGesture {
            path.append(.detail(productIndex: index))
        }
    }
}

