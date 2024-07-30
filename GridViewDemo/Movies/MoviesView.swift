//
//  MoviesView.swift
//  GridViewDemo
//
//  Created by Tanvir Rahman on 28/7/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(CategoryMovies.allCases) { category in
                            Button(action: {
                                viewModel.selectedCategory = category
                                viewModel.filterMovies()
                            }) {
                                Text(category.rawValue)
                                    .padding(10)
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 12, weight: .bold))
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.gray,lineWidth: 1)
                                            .background(
                                                viewModel.selectedCategory == category ? Color.secondary : Color.clear
                                            ).cornerRadius(20)
                                    )
                                
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.leading, 10)
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(viewModel.filteredWebMoviesList) { movies in
                            MoviesCardView(movies:movies)
                                .onAppear {
                                    if movies == viewModel.filteredWebMoviesList.last {
                                        viewModel.fetchWebSeries()
                                    }
                                }
                            
                        }
                    }
                }
            }
        }
    }
}

struct MoviesCardView: View {
    let movies: MoviesData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
                WebImage(url: URL(string:  movies.thumbnailUrl))
                    .resizable()
                    .scaledToFit()
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(movies.title)
                        .font(.system(size: 14,weight: .bold))
                        .lineLimit(1)
                    Spacer()
                    Button {
                        
                    }label: {
                        Image("more-dot")
                            .frame(width: 5, height: 10)
                            .padding(.trailing, 10)
                    }.buttonStyle(.plain)
                }
                HStack(spacing: 5){
                    Text("Toffee")
                        .font(.system(size: 13,weight: .medium))
                        .foregroundColor(.secondary)
                    Circle().foregroundColor(.gray)
                        .frame(height: 3)
                    Text(movies.timeAgo)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct MoviesCardView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
        //        WebSeriesCardView(series: WebSeries(title: "Series 1", thumbnailUrl: "https://via.placeholder.com/150", episodeCount: 10, timeAgo: "12h ago", category: .thriller))
        //            .previewLayout(.sizeThatFits)
        //            .padding()
    }
}
