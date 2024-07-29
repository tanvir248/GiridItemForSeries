//
//  MovieModel.swift
//  GridViewDemo
//
//  Created by Tanvir Rahman on 28/7/24.
//

import Foundation

enum CategoryMovies: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case comedy = "Comedy"
    case thriller = "Thriller"
    case horror = "Horror"
    case romance = "Romance"

    var id: String { self.rawValue }
}

struct MoviesData: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let thumbnailUrl: String
    let timeAgo: String
    let category: Category
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailUrl
        case timeAgo
        case category
    }
    
    // Implement the Equatable protocol by defining the == operator
    static func ==(lhs: MoviesData, rhs: MoviesData) -> Bool {
        return lhs.id == rhs.id
    }
}
