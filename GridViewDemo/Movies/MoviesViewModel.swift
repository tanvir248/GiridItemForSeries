//
//  MovieViewModel.swift
//  GridViewDemo
//
//  Created by Tanvir Rahman on 28/7/24.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var moviesList: [MoviesData] = []
    @Published var filteredWebMoviesList: [MoviesData] = []
    @Published var selectedCategory: CategoryMovies = .all
    
    init() {
        loadDummyData()
    }
    
    func loadDummyData() {
        func loadData() {
            APIManager.shared.fetchArrayData(url: "https://dummyjson.com/c/8faa-7c29-4917-8b40") { (result: Result<[MoviesData], Error>) in
                switch result {
                case .success(let data):
                    self.moviesList = data
                    self.filterMovies()
                case .failure(let error):
                    print("Failed to fetch data: \(error.localizedDescription)")
                }
            }
        }
    }
        
    func filterMovies() {
        if selectedCategory == .all {
            filteredWebMoviesList = moviesList
        } else {
            filteredWebMoviesList = moviesList.filter { $0.category.rawValue == selectedCategory.id }
        }
    }
}
