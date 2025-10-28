//
//  NetworkManager.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 20.10.2025.
//

import Foundation

class NetworkManagerAsync{
    let photoApiKey = "cPbP9CvODNveDaCsh72J61E62xzIsLUbpTpVOCJPbbs"
    let cityApiKey = "f69b9f26ce034121a15a2cb987a9a5aa"
    
    func sendCityRequest(filterApi: String) async throws -> ResponceCity {
        var urlComponents = URLComponents(string: "https://api.geoapify.com")
        urlComponents?.path = "/v2/places"
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "categories", value: "tourism.sights"),
            URLQueryItem(name: "conditions", value: "named"),
            URLQueryItem(name: "filter", value: "circle:\(filterApi)"),
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "apiKey", value: cityApiKey),
        ]
        
        guard let url = urlComponents?.url else{
            throw URLError.badURL
        }
        
        let responce = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let result = try decoder.decode(ResponceCity.self, from: responce.0)
        
        return result
    }
    
    func sendPhotoRequest(query: String) async throws -> ResponceImage {
        var urlComponents = URLComponents(string: "https://api.unsplash.com")
        urlComponents?.path = "/search/photos"
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: photoApiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "orientation", value: "landscape"),
        ]
        
        guard let url = urlComponents?.url else{
            throw URLError.badURL
        }
        
        
        let responce = try await URLSession.shared.data(from: url)
        print(responce)
        let decoder = JSONDecoder()
        let result = try decoder.decode(ResponceImage.self, from: responce.0)
        
        return result
    }
    
}
