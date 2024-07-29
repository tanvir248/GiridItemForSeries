//
//  WebSeriesViewModel.swift
//  GridViewDemo
//
//  Created by Shafique on 7/15/24.
//

import Foundation
import Combine

class WebSeriesViewModel: ObservableObject {
    @Published var webSeriesList: [WebSeries] = []
    @Published var filteredWebSeriesList: [WebSeries] = []
    @Published var selectedCategory: Category = .all
    
    init() {
        loadDummyData()
    }
    
    private func loadDummyData() {
        guard let url = Bundle.main.url(forResource: "dummy_web_series", withExtension: "json") else {
            print("Failed to find dummy_web_series.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let webSeries = try JSONDecoder().decode([WebSeries].self, from: data)
            self.webSeriesList = webSeries
            filterWebSeries()
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
            .decode(type: [WebSeries].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Failed to fetch data: \(error.localizedDescription)")
                }
            }, receiveValue: { webSeries in
                self.webSeriesList.append(contentsOf: webSeries)
                self.currentPage += 1
            })
            .store(in: &self.cancellables)
    }
    
    func filterWebSeries() {
        if selectedCategory == .all {
            filteredWebSeriesList = webSeriesList
        } else {
            filteredWebSeriesList = webSeriesList.filter { $0.category == selectedCategory }
        }
    }
}
