//
//  WebSeriesCardView.swift
//  GridViewDemo
//
//  Created by Tanvir Rahman on 30/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

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
                            .foregroundColor(.primary)
//                            .matchedGeometryEffect(id: "more-tapped", in: namespace)
                            .onTapGesture {
                                if showMenu {
                                    videoID = ""
                                    bgColor = Color.clear
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
                        Circle().foregroundColor(.secondary)
                            .frame(height: 3)
                        Text(series.timeAgo)
                            .font(.footnote)
                            .foregroundColor(.secondary)
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
#Preview {
    WebSeriesCardView(series: .init(title: "Dhaka Attack", thumbnailUrl: "https//:abec.com.sdfsd.jpeg", episodeCount: 3, timeAgo: "7", videoId: "werew0", category: .comedy), showMenu: .constant(false), videoID: .constant("2343"), bgColor: .constant(Color.clear))
}
