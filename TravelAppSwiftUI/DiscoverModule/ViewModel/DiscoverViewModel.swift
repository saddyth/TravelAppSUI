
import Foundation
import SwiftUI

@Observable
final class DiscoverViewModel: Identifiable {
    // MARK: - Variables
    private let networkManager = NetworkManagerAsync.shared
    private var likesStorage: LikeStorage = LikeStorage.shared
    private var responceCity: ResponceCity.Feature?
    private var responceImage: ResponceImage.ImageUrls?
    private var hasLoaded = false
    
    var categories: [Category] = [
        Category(name: "All"),
        Category(name: "Popular"),
        Category(name: "Featured"),
        Category(name: "Most Visited"),
        Category(name: "Europe"),
        Category(name: "Asia"),
    ]
    
    var selectedCategory: Category? = Category(name: "All")
    
    var products: [Product] = [
        Product(id: UUID(uuidString: "F7F9B0C3-CB68-410B-AED7-AC33CFE6A0DA")!, image: .placeholder, title: "...", rating: 4, place: "Rome, Italy",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 200,
                isLiked: true,
                filterApi: "12.489432941845962,41.890326287858755,10000",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Popular")]),
        
        Product(id: UUID(uuidString: "772AEE0E-289A-4205-9380-8BFF29ED70D8")!,image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "2.2945233683636843,48.85823839996263,100",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Europe"), Category(name: "Featured")]
               ),
        Product(id: UUID(uuidString: "28F856C1-E6E4-4DCE-AE5A-8BE64CC14B11")!,image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "9.19157232050702,45.4641766670901,100",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Most Visited")]
               ),
        Product(id: UUID(uuidString: "78A153C2-8F3D-4961-AE8B-1661AE5C1EB7")!,image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "-3.7016229295667245,40.415909232509364,10000",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Asia")]
               ),
        Product(id: UUID(uuidString: "00CA849B-65FC-4EBC-AC33-9DE55A4C61AF")!,image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "136.89889631116648,35.17317054715964,10000",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Featured"),Category(name: "Asia")]
               ),
        Product(id: UUID(uuidString: "F3EA4AA6-1048-4BFD-87FF-785EA604AF83")!,image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "13.397589974164248,52.51221037226915,500",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Europe")]
               ),
    ]
    
    //MARK: - Init
    init() {
        Task {
            await fetchLikes()
        }
        setupObservers()
    }
    //MARK: - Observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name("signIn"), object: nil, queue: .main) { [weak self] _ in
            Task {
                await self?.fetchLikes()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("signOut"), object: nil, queue: .main) { [weak self] _ in
            self?.resetLikes()
        }
    }
    
    //MARK: - Likes
    func updateLike(for product: Product) {
        guard let index = products.firstIndex(where: {$0.id == product.id})
        else {return}
        products[index].isLiked.toggle()
        Task {
            await likesStorage.toggleLike(for: products[index])
        }
    }
    
    private func fetchLikes() async {
        await likesStorage.fetchLikes()
        for index in products.indices {
            products[index].isLiked = likesStorage.isLiked(id: products[index].id)
        }
    }
    
    private func resetLikes() {
        for index in products.indices {
            products[index].isLiked = false
        }
    }
    
    //MARK: - Rating
    func updateStars(for product: Product, to newRating: Int) {
        guard let index = products.firstIndex(where: {$0.id == product.id})
        else {return}
        products[index].rating = newRating
    }
    
    //MARK: - Filter
    var filteredProducts: [Product] {
        guard let selected = selectedCategory else {return products}
        return products.filter{$0.category.contains{$0.name == selected.name}}
    }
    
    func isSelected(category: Category) {
        selectedCategory = category
    }
    
    //MARK: - Fetch cities and photos
    func fetchData() async {
        await withThrowingTaskGroup(of: Void.self) { group in
            for (index, _) in products.enumerated() {
                group.addTask { [self] in
                    do {
                        let cityResult = try await networkManager.sendCityRequest(filterApi: products[index].filterApi)
                        responceCity = cityResult.features.first
                        if let nameInternational = responceCity?.properties.name_international.en,
                           let sightCity = responceCity?.properties.city,
                           let sightCountry = responceCity?.properties.country  {
                            
                            await MainActor.run {
                                products[index].title = nameInternational
                                products[index].place = "\(sightCity), \(sightCountry)"
                            }
                            
                            do {
                                let photoresult = try await networkManager.sendPhotoRequest(query: products[index].title)
                                if let regular = photoresult.urls.regular {
                                    await MainActor.run {
                                        products[index].imageURL = URL(string: regular)
                                    }
                                }
                            } catch {
                                print("Unable to load photos \(error.localizedDescription)")
                            }
                            
                        }
                    }
                    catch {
                        print("Unable to load cities \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func loadTask() async {
        if hasLoaded == false {
            hasLoaded = true
            await fetchData()
        }
    }
}
