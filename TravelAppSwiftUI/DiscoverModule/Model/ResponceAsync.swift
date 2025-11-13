//
//  Responce.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 20.10.2025.
//

import Foundation

struct ResponceImage: Decodable {
        let urls: ImageUrls
        struct ImageUrls: Decodable {
            let regular: String?
        }
}

struct ResponceCity: Decodable {
    let features: [Feature]
        struct Feature: Decodable{
            
            let properties: SightInfo
            
            struct SightInfo: Decodable {
                let name_international: NameInternational
                let country: String?
                let city: String?
                
                struct NameInternational: Decodable {
                    let en: String?
                }
            }
        }
}

enum URLError: Error {
    case badURL, badRequest, badResponce, invalidData
}
