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

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            ZStack {
                                HStack {
                                    ForEach(Category.allCases) { category in
                                        Button(action: {
                                            viewModel.selectedCategory = category
                                            viewModel.filterWebSeries()
                                            videoIDArray = [:]
                                            updateVideoIDArray()
                                            videoID = ""
                                            withAnimation {
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
                                                        .stroke(.white,lineWidth: 1)
                                                        .background(
                                                            viewModel.selectedCategory == category ? Color.secondary : Color.clear
                                                        ).cornerRadius(20)
                                                )
                                            
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                                .padding(.leading, 10)
                                if showMenu {
                                    Color.black.opacity(0.5)
                                        .padding(.vertical, -10)
                                        .onTapGesture {
                                            withAnimation {
                                                showMenu = false
                                            }
                                        }.frame(height: 44)
                                        
                                }
                            }
                        }.simultaneousGesture(
                            DragGesture().onChanged { value in
                                withAnimation {
                                    videoID = ""
                                    showMenu = false
                                }
                            }
                         )
                    
                    ScrollView(showsIndicators: true){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                            ForEach(viewModel.filteredWebSeriesList) { series in
                                ZStack(alignment: .bottomTrailing){
                                    WebSeriesCardView(series: series, showMenu: $showMenu, videoID: $videoID)
                                        .padding(.horizontal, 2)
                                        .onAppear {
                                            if series == viewModel.filteredWebSeriesList.last {
                                                viewModel.fetchWebSeries()
                                            }
                                        }
                                    if showMenu{
                                        Color.black.opacity(0.5)
                                            .padding(.horizontal, -4)
                                            .padding(.vertical, -10)
                                            .onTapGesture {
                                                withAnimation(.spring){
                                                    videoID = ""
                                                    showMenu = false
                                                }
                                            }
                                    }
                                    if showMenu, videoIDArray[series.videoId] == true {
                                        MoreMenuView(videoId: series.videoId){
                                            withAnimation {
                                                videoID = ""
                                                showMenu = false
                                            }
                                        }.padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }.simultaneousGesture(
                        DragGesture().onChanged { value in
                            withAnimation {
                                videoID = ""
                                showMenu = false
                            }
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
                showMenu = false
                updateVideoIDArray()
            }
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
                }.onTapGesture {
                    videoID = ""
                    withAnimation {
                        showMenu = false
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(series.title)
                            .font(.system(size: 14,weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
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
                    }
                }
            }
        }
    }
}

struct WebSeriesCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //        WebSeriesCardView(series: WebSeries(title: "Series 1", thumbnailUrl: "https://via.placeholder.com/150", episodeCount: 10, timeAgo: "12h ago", category: .thriller))
        //            .previewLayout(.sizeThatFits)
        //            .padding()
    }
}



/*
 Image("more-dot")
 .frame(width: 5, height: 10)
 .padding(.trailing, 10)
 .contextMenu {
 Button {
 print("Change country setting")
 } label: {
 Label("Choose Country", systemImage: "globe")
 }
 
 Button {
 print("Enable geolocation")
 } label: {
 Label("Detect Location", systemImage: "location.circle")
 }
 }
 */
//                    Menu {
//                        Button {
//                            print("Change country setting")
//                        } label: {
//                            Text("Add to Playlists")
//                        }
//
//                        Button {
//                            print("Enable geolocation")
//                        } label: {
//                           Text("Share")
//                        }
//
//                        Button {
//                            print("Enable geolocation")
//                        } label: {
//                           Text("Report")
//                        }
//
//                    } label: {
