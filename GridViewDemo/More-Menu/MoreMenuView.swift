//
//  moreMenuView.swift
//  GridViewDemo
//
//  Created by Tanvir Rahman on 29/7/24.
//

import SwiftUI

struct MoreMenuView: View {
    var videoId: String
    var dismissAction: (() -> Void)?
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            menuText("Add to Favorites")
                .onTapGesture {
                    dismissAction?()
                    print("Add to Favorites \(videoId)")
                }
            menuText("Add to playlist")
                .onTapGesture {
                    dismissAction?()
                    print("Add to playlist \(videoId)")
                }

            menuText("Share")
                .onTapGesture {
                    dismissAction?()
                    print("Share \(videoId)")
                }
            menuText("Report")
                .onTapGesture {
                    dismissAction?()
                    print("Report \(videoId)")
                }

        }.padding(10)
            .background(Color("menu-color").cornerRadius(5))
    }
    @ViewBuilder func menuText(_ text: String) -> some View {
         Text(text)
            .font(.footnote)
            .foregroundColor(.white)
            .bold()
    }
}

#Preview {
    MoreMenuView(videoId: "00")
}
