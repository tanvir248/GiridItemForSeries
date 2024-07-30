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
                        //                        .overlay(
                        //                            colorx
                        //                                .onTapGesture {
                        //                                    colorx = Color.clear
                        //                                    videoID = ""
                        //                                    showMenu = false
                        //                                }
                        //                        )
                        
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
                                                viewModel.fetchWebSeries()
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

struct WebSeriesCardView: View {
    let series: WebSeries
    @Namespace private var namespace
    @Binding var showMenu: Bool
    @Binding var videoID: String
    @Binding var bgColor: Color
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack(alignment: .leading, spacing: 5) {
                ZStack {
                    WebImage(url: URL(string:  series.thumbnailUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(height: 100)
                            .scaledToFill()
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Image("webSeriesPlaylist")
                            Text("\(series.episodeCount) Episodes")
                                .font(.system(size: 10, weight: .bold))
                            Spacer()
                        }.padding(.horizontal, 5)
                            .background(
                                VStack {
                                    Color.black.opacity(0.5)
                                }
                            )
                    }
                    if showMenu {
                        Color("shadowColor").opacity(0.6)
                    }else {
                        Color.clear
                    }
                }.onTapGesture {
                    bgColor = Color.clear
                    videoID = ""
                    showMenu = false
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(series.title)
                            .font(.system(size: 14,weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .onTapGesture {
                                bgColor = Color.clear
                                videoID = ""
                                showMenu = false
                            }
                        Spacer()
                        Image("more-dot")
                            .frame(width: 5, height: 10)
                            .padding(.trailing, 10)
                            .matchedGeometryEffect(id: "more-tapped", in: namespace)
                            .onTapGesture {
                                if showMenu {
                                    videoID = ""
                                    withAnimation {
                                        showMenu = false
                                    }
                                    
                                }else {
                                    videoID = series.videoId
                                    withAnimation {
                                        bgColor = Color("shadowColor").opacity(0.6)
                                        showMenu = true
                                    }
                                }
                            }
                    }
                    HStack(spacing: 5){
                        Text("Toffee")
                            .font(.system(size: 13,weight: .medium))
                            .foregroundColor(.secondary)
                        Circle().foregroundColor(.gray)
                            .frame(height: 3)
                        Text(series.timeAgo)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }.onTapGesture {
                        bgColor = Color.clear
                        videoID = ""
                        showMenu = false
                    }
                }
            }
        }
    }
}

struct WebSeriesCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



