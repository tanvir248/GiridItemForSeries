//
//  moreMenuView.swift
//  GridViewDemo
//
//  Created by Tanvir Rahman on 29/7/24.
//

import SwiftUI
enum moreMenuActionType {
    case addToFavoritesTapped
    case addToPlayListsTapped
    case shareTapped
    case reportTapped
}

enum moreMenuOptionType {
    case addToFavorites
    case addToPlayLists
    case share
    case report
}

struct MoreMenuView: View {
    var videoId: String
    var options: [moreMenuOptionType?]
    var dismissAction: ((moreMenuActionType?) -> Void)?
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            ForEach(options, id: \.self) { option in
                switch option {
                case .addToFavorites:
                    menuText("Add to Favorites")
                        .onTapGesture {
                            dismissAction?(.addToFavoritesTapped)
                        }
                    
                case .addToPlayLists:
                    menuText("Add to playlist")
                        .onTapGesture {
                            dismissAction?(.addToPlayListsTapped)
                        }
                    
                case .share:
                    menuText("Share")
                        .onTapGesture {
                            dismissAction?(.shareTapped)
                        }
                    
                case .report:
                    menuText("Report")
                        .onTapGesture {
                            dismissAction?(.reportTapped)
                        }
                case .none:
                    menuText("Empty")
                        .onTapGesture {
                            dismissAction?(.none)
                        }
                }
                
            }
        }.padding(10)
            .background(Color("menu-color").cornerRadius(5))
    }
    @ViewBuilder func menuText(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
            .bold()
    }
}

#Preview {
    MoreMenuView(videoId: "00", options: [.addToFavorites, .report]) {_ in
        
    }
}
