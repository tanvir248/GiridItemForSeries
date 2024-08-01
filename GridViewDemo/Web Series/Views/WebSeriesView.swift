//
//  WebSeriesView.swift
//  GridViewDemo
//
//  Created by Shafique on 7/15/24.
//
import SwiftUI
import SDWebImageSwiftUI

struct WebSeriesView: View {
    @StateObject private var viewModel = WebSeriesViewModel()
    @State private var videoIDArray: [String : Bool] = [:]
    @State private var showMenu: Bool = false
    @State private var videoID: String = ""
    @State private var bgColor: Color = Color.clear
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Category.allCases) { category in
                                Button(action: {
                                    viewModel.selectedCategory = category
                                    viewModel.filterWebSeries()
                                    videoIDArray = [:]
                                    updateVideoIDArray()
                                    videoID = ""
                                    withAnimation {
                                        bgColor = Color.clear
                                        showMenu = false
                                    }
                                    
                                }) {
                                    Text(category.rawValue)
                                        .padding(10)
                                        .padding(.horizontal, 10)
                                        .foregroundColor(.primary)
                                        .font(.system(size: 12, weight: .bold))
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.gray.opacity(0.3),lineWidth: 2)
                                                .background(
                                                    viewModel.selectedCategory == category ? Color.secondary : Color.clear
                                                ).cornerRadius(20)
                                        )
                                    
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                    }.simultaneousGesture(
                        DragGesture().onChanged { value in
                            bgColor = Color.clear
                            videoID = ""
                            showMenu = false
                        }
                    )
                    ScrollView(showsIndicators: true){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                            ForEach(viewModel.filteredWebSeriesList) { series in
                                ZStack(alignment: .bottomTrailing){
                                    WebSeriesCardView(series: series, showMenu: $showMenu, videoID: $videoID, bgColor: $bgColor)
                                        .padding(.horizontal, 2)
                                        .onAppear {
                                            if series == viewModel.filteredWebSeriesList.last {
                                                viewModel.loadData()
                                            }
                                        }
                                    if showMenu, videoIDArray[series.videoId] == true {
                                        MoreMenuView(videoId: series.videoId, options: [.addToFavorites, .addToPlayLists, .share, .report]){ action in
                                            bgColor = Color.clear
                                            videoID = ""
                                            showMenu = false
                                            switch action {
                                            case .addToFavoritesTapped:
                                                print("add to favorites tapped")
                                            case .addToPlayListsTapped:
                                                print("add to playlists tapped")
                                            case .shareTapped:
                                                print("share tapped")
                                            case .reportTapped:
                                                print("report Tapped")
                                            case .none:
                                                print("Empty view")
                                            }
                                        }.padding(.horizontal)
                                    }
                                }
                                
                            }
                        }
                    }.simultaneousGesture(
                        DragGesture().onChanged { value in
                            bgColor = Color.clear
                            videoID = ""
                            showMenu = false
                        }
                    )
                    .navigationBarItems(trailing:
                                            HStack {
                        
                        NavigationLink("See Movies") {
                            MoviesView()
                        }
                    }
                    )
                }
            }.onAppear {
                print(" appeared")
                bgColor = Color.clear
                showMenu = false
                updateVideoIDArray()
            }
            .background(
                bgColor.edgesIgnoringSafeArea(.bottom)
                    .onTapGesture {
                        bgColor = Color.clear
                        videoID = ""
                        showMenu = false
                    }
            )
            .onChange(of: videoID) { newValue in
                if showMenu && !videoID.isEmpty{
                    updateVideoIDArray(newValue)
                }
            }
        }
    }
    func updateVideoIDArray(_ videoID: String? = ""){
        
        for index in viewModel.filteredWebSeriesList {
            if index.videoId == videoID {
                videoIDArray[index.videoId] = true
            }else {
                videoIDArray[index.videoId] = false
            }
        }
    }
}


struct WebSeriesCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



