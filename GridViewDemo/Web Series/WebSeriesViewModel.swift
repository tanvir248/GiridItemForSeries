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
    @Published var isLoading = false
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
    }
    
    func loadData() {
        APIManager.shared.fetchArrayData(url: "https://dummyjson.com/c/8faa-7c29-4917-8b40") { (result: Result<[WebSeries], Error>) in
            switch result {
            case .success(let data):
                self.webSeriesList = data
                self.filterWebSeries()
            case .failure(let error):
                print("Failed to fetch data: \(error.localizedDescription)")
            }
        }
    }
    
    func filterWebSeries() {
        if selectedCategory == .all {
            filteredWebSeriesList = webSeriesList
        } else {
            filteredWebSeriesList = webSeriesList.filter { $0.category == selectedCategory }
        }
    }
}
