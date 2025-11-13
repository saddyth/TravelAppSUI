//
//  ProductDetailView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka on 14.10.2025.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    var discoverVM: DiscoverViewModel
    @Binding var product: Product
    @State private var counter = 1
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                if let imageURL = product.imageURL {
                    KFImage(imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height * 0.6)
                        .clipShape(RoundedRectangle(cornerRadius: 19))
                } else {
                    Image(.placeholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height * 0.6)
                        .clipShape(RoundedRectangle(cornerRadius: 19))
                }
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        ZStack{
                            Rectangle()
                                .foregroundStyle(.white)
                                .frame(minHeight: geo.size.height * 0.58)
                                .clipShape(RoundedRectangle(cornerRadius: 37))
                            VStack{
                                Text(product.title)
                                    .merriweather(type: .black, size: 24)
                                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .topLeading)
                                    .padding(.leading, 30)
                                    .padding(.top, 40)
                                HStack{
                                    Image(.mapMarker)
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .padding(.leading, 30)
                                    Text(product.place)
                                        .merriweather(type: .bold, size: 12)
                                }
                                .frame(height: 15)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.top, 5)
                                
                                RatingView(discoverVM: discoverVM, product: $product, textColor: .black)
                                    .frame(maxWidth: .infinity, maxHeight: 20, alignment: .topLeading)
                                    .padding(.leading, 30)
                                HStack {
                                    ZStack{
                                        Rectangle()
                                            .foregroundStyle(.incrementRectangle)
                                            .clipShape(RoundedRectangle(cornerRadius: 18))
                                        HStack{
                                            Button(action: {
                                                if counter > 1 {
                                                    counter -= 1
                                                }
                                            }, label: {
                                                Text("-")
                                                    .foregroundStyle(.white)
                                            })
                                            .frame(width: 29, height: 36)
                                            .background(.main)
                                            .clipShape(RoundedRectangle(cornerRadius: 13))
                                            
                                            Spacer()
                                            
                                            Text("\(counter)")
                                                .sourceSans3(type: .bold, size: 16)
                                            
                                            Spacer()
                                            Button(action: {
                                                if counter < 20 {
                                                    counter += 1
                                                }
                                            }, label: {
                                                Text("+")
                                                    .foregroundStyle(.white)
                                            })
                                            .frame(width: 29, height: 36)
                                            .background(.main)
                                            .clipShape(RoundedRectangle(cornerRadius: 13))
                                        }
                                    }
                                    .frame(width: 104, height: 36)
                                    
                                    Image(.clock)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 10)
                                    Text("\(counter) Day")
                                        .sourceSans3(type: .semiBold, size: 18)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .topLeading)
                                .padding(.leading, 30)
                                .padding(.top, 10)
                                
                                VStack(spacing: 5){
                                    Text("Description")
                                        .merriweather(type: .bold, size: 20)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(product.description)
                                        .sourceSans3(type: .regular, size: 18)
                                        .minimumScaleFactor(0.7)
                                        .frame(maxWidth: .infinity, minHeight: geo.size.height * 0.1, alignment: .topLeading)
                                        .padding(.top, 15)
                                }
                                .padding(.horizontal, 30)
                                .padding(.top, 15)
                                .padding(.bottom, geo.size.height * 0.03)
                                
                                HStack{
                                    HStack(spacing: 0){
                                        Text("\(product.price * counter)$")
                                            .sourceSans3(type: .bold, size: 30)
                                            .foregroundStyle(.main)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        
                                        Text("/Package")
                                            .sourceSans3(type: .bold, size: 18)
                                            .foregroundStyle(.main)
                                    }
                                    Spacer()
                                    Button(action: {
                                       //book action
                                    }, label: {
                                        Text("Book now")
                                            .merriweather(type: .black, size: 18)
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: geo.size.width * 0.35)
                                            .minimumScaleFactor(0.5)
                                    })
                                    .frame(width: geo.size.width * 0.35, height: 50)
                                    .background(.main)
                                    .clipShape(RoundedRectangle(cornerRadius: 28))
                                }
                                .padding(.horizontal, 30)
                                .padding(.bottom, 30)
                            }
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 37))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProductDetailView(discoverVM: DiscoverViewModel(), product: .constant(Product(id: UUID(uuidString: "F3EA4AA6-1048-4BFD-87FF-785EA604AF83")!,image: .placeholder, title: "Japan", rating: 4, place: "Ffkd", description: "dkdkfl", price: 469, isLiked: false, filterApi: "fkdfkdf", category: [Category(name: "All"), Category(name: "Popular")])))
}
