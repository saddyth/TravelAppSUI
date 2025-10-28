//
//  DiscoverView.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 14.10.2025.
//

import SwiftUI
import Kingfisher
struct DiscoverView: View {
    @State var discoverVM: DiscoverViewModel
    @State private var isTapped = false
    @Binding var path: [Screen]
    
    var body: some View {
        VStack{
            HeaderView()
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(discoverVM.categories) {category in
                        Button(action: {
                            discoverVM.isSelected(category: category)
                        }, label: {
                            Text(category.name)
                                .sourceSans3(type: .regular, size: 16)
                                .foregroundStyle((discoverVM.selectedCategory?.name == category.name) ? .main : .black)
                                .frame(height: 20)
                        })
                        .padding(.trailing, 30)
                        .clipShape(RoundedRectangle(cornerRadius: 19))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 30)
            }
            
            ProductsTabView(discoverVM: discoverVM, size: .large, path: $path)
            
            HStack {
                Text("Recommended")
                    .merriweather(type: .bold, size: 18)
                    .padding(.leading, 36)
                Spacer()
                Text("View all")
                    .merriweather(type: .regular, size: 14)
                    .padding(.trailing, 25)
            }
            ProductsTableView(discoverVM: discoverVM, size: .small, path: $path)
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            Task{
                await discoverVM.loadTask()
            }
        }
    }
}


struct ProductsTableView: View {
    @Bindable var discoverVM: DiscoverViewModel
    let size: ProductCardSize
    @Binding var path: [Screen]
    
    var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width * size.cardWidth
            let cardHeight = cardWidth
            let rectangleHeight = cardHeight * 0.32
            let columnWidth = geo.size.width * 0.42
            let titleSize = geo.size.width * size.titleSize
            let columns = [
                GridItem(.fixed(columnWidth), spacing: 20),
                GridItem(.fixed(columnWidth), spacing: 0)
            ]
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20){
                        ForEach(discoverVM.filteredProducts.indices, id: \.self) { index in
                            if let originalIndex = discoverVM.products.firstIndex(where: {$0.id == discoverVM.filteredProducts[index].id}){
                                ProductCardView(cardWidth: cardWidth, cardHeight: cardHeight, rectangleHeight: rectangleHeight, titleSize: titleSize, product: $discoverVM.products[originalIndex], discoverVM: discoverVM, path: $path, index: originalIndex)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}


struct ProductsTabView: View {
    @Bindable var discoverVM: DiscoverViewModel
    @State var currentPage = 0
    @State private var activeID: UUID?
    let size: ProductCardSize
    @Binding var path: [Screen]
    
    var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width * size.cardWidth
            let cardHeight = cardWidth * 0.8
            let rectangleHeight = cardHeight * 0.3
            let titleSize = geo.size.width * size.titleSize
            VStack(spacing: 16){
                TabView(selection: $currentPage) {
                    ForEach(discoverVM.products.indices, id: \.self) { index  in
                        ProductCardView(cardWidth: cardWidth, cardHeight: cardHeight, rectangleHeight: rectangleHeight, titleSize: titleSize, product: $discoverVM.products[index], discoverVM: discoverVM, path: $path, index: index)
                            .tag(index)
                            .frame(maxWidth: cardWidth)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(minHeight: cardHeight)
                
                PageControl(numberOfPages: discoverVM.products.count, currentPage: currentPage) { value in
                    activeID = discoverVM.products[value].id
                }
                .frame(width: 10, height: 10)
            }
            .frame(maxWidth: .infinity, minHeight: cardHeight)
        }
        .frame(minHeight: 280, maxHeight: 300)
        .padding(.vertical, 20)
    }
}

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
            KFImage(product.imageURL)
                .placeholder {
                    Image(.placeholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardWidth, height: cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 19))
                }
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipShape(RoundedRectangle(cornerRadius: 19))
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


struct HeaderView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }, label: {
                Image(.leftArrowBlack)
            })
            Spacer()
            Text("Discover")
                .merriweather(type: .regular, size: 27)
            Spacer()
            ZStack{
                Image(.avatar)
                    .scaledToFit()
                Circle()
                    .fill(.avatarNotification)
                    .frame(width: 9, height: 9)
                    .padding(.leading, 5)
                    .padding(.trailing, 30)
                    .padding(.top, 36)
            }
        }
    }
}

#Preview {
    DiscoverView(discoverVM: DiscoverViewModel(), path: .constant([]))
}


