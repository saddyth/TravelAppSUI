
import Foundation
import Kingfisher
@Observable
class DiscoverViewModel: Identifiable {
    private let networkManager = NetworkManagerAsync()
    var responceCity: ResponceCity.Feature?
    var responceImage: ResponceImage.ImageUrls?
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
        Product(image: .placeholder, title: "...", rating: 4, place: "Rome, Italy",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 200,
                isLiked: true,
                filterApi: "12.489432941845962,41.890326287858755,10000",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Popular")]),
        
        Product(image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "2.2945233683636843,48.85823839996263,100",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Europe"), Category(name: "Featured")]
               ),
        Product(image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "9.19157232050702,45.4641766670901,100",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Most Visited")]
               ),
        Product(image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "-3.7016229295667245,40.415909232509364,10000",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Asia")]
               ),
        Product(image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "136.89889631116648,35.17317054715964,10000",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Featured"),Category(name: "Asia")]
               ),
        Product(image: .placeholder, title: "...", rating: 5, place: "?",
                description: "One of the most iconic peaks in the Alps, known for its perfect pyramidal shape. Towering over picturesque villages, the Matterhorn offers breathtaking views and attracts adventurers from around the world.",
                price: 220,
                isLiked: false,
                filterApi: "13.397589974164248,52.51221037226915,500",
                imageURL: nil,
                category: [Category(name: "All"), Category(name: "Europe")]
               ),
    ]
    
    func updateStars(for product: Product, to newRating: Int) {
        guard let index = products.firstIndex(where: {$0.id == product.id})
        else {return}
        products[index].rating = newRating
    }
    
    func updateLike(for product: Product) {
        guard let index = products.firstIndex(where: {$0.id == product.id})
        else {return}
        products[index].isLiked.toggle()
    }
    
    var filteredProducts: [Product] {
        guard let selected = selectedCategory else {return products}
        return products.filter{$0.category.contains{$0.name == selected.name}}
    }
    
    func isSelected(category: Category) {
        selectedCategory = category
    }
    
    func loadTask() async {
        if hasLoaded == false {
            hasLoaded = true
            await fetchData()
        }
    }
    
    func fetchData() async {
        for (index, _) in products.enumerated() {
            do {
                let cityResult = try await networkManager.sendCityRequest(filterApi: products[index].filterApi)
                responceCity = cityResult.features.first
                if let nameInternational = responceCity?.properties.name_international.en,
                   let sightCity = responceCity?.properties.city,
                   let sightCountry = responceCity?.properties.country  {
                    
                    //photo request
                    
                    await MainActor.run {
                        products[index].title = nameInternational
                        products[index].place = "\(sightCity), \(sightCountry)"
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
