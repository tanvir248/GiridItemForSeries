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
    
    private func loadDummyData() {
        guard let url = Bundle.main.url(forResource: "dummy_movies_data", withExtension: "json") else {
            print("Failed to find dummy_web_series.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let moviesList = try JSONDecoder().decode([MoviesData].self, from: data)
            self.moviesList = moviesList
            filterMovies()
        } catch {
            print("Failed to load or decode dummy data: \(error.localizedDescription)")
        }
    }
    
    @Published var isLoading = false
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWebSeries() {
        guard !isLoading else { return }
        isLoading = true
        
        let urlString = "https://example.com/api/webseries?page=\(currentPage)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [MoviesData].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Failed to fetch data: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                self.moviesList.append(contentsOf: movies)
                self.currentPage += 1
            })
            .store(in: &self.cancellables)
    }
    
    func filterMovies() {
        if selectedCategory == .all {
            filteredWebMoviesList = moviesList
        } else {
            filteredWebMoviesList = moviesList.filter { $0.category.rawValue == selectedCategory.id }
        }
    }
}
