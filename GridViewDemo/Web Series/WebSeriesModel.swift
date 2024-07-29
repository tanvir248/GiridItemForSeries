//
//  WebSeries.swift
//  GridViewDemo
//
//  Created by Shafique on 7/15/24.
//

import Foundation

enum Category: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case thriller = "Thriller"
    case romance = "Romance"
    case comedy = "Comedy"
    case horror = "Horror"
    
    var id: String { self.rawValue }
}

struct WebSeries: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let thumbnailUrl: String
    let episodeCount: Int
    let timeAgo: String
    let videoId: String
    let category: Category
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailUrl
        case episodeCount
        case timeAgo
        case videoId
        case category
        
    }
    
    // Implement the Equatable protocol by defining the == operator
    static func ==(lhs: WebSeries, rhs: WebSeries) -> Bool {
        return lhs.id == rhs.id
    }
}
