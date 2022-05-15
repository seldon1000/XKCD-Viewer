//
//  FeedView.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var comicModel: ComicModel
    @EnvironmentObject var navController: NavController
    
    @Binding var scroll: Bool
    
    let id: Namespace.ID
    
    var body: some View {
        ScrollViewReader { proxy in // This allows to scroll to an item programmatically
            ScrollView {
                ForEach(0..<comicModel.comics.count, id: \.self) { comic in // Iterate throughout the comics list
                    if navController.current == .feed || (navController.current == .details && navController.last == .feed) { // Insert little section titles if necessary
                        if comic == 0 {
                            Text("Today's Feature")
                                .font(.system(size: 18, weight: .bold))
                                .padding([.horizontal, .top])
                                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        } else if comic == 1 {
                            Text("History")
                                .font(.system(size: 18, weight: .bold))
                                .padding([.horizontal, .top])
                                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        }
                    }
                    ComicCardView(comic: comic, id: id) // Add a comic card
                        .id(comic) // Use this to make the scroll proxy work as expected
                        .frame(maxHeight: ((navController.current == .favourites && comicModel.comics[comic].isFavourite) || navController.current == .feed || (navController.current == .details && navController.last == .favourites && comicModel.comics[comic].isFavourite) || (navController.current == .details && navController.last == .feed)) ? .infinity : 0) // Instead of using another view for favourites, just collapse the comic cards which have to disappear
                    
                }
                if comicModel.comics.count > 0 && navController.current == .feed { // Add a pull to refresh view
                    PullToRefresh {
                        Task {
                            do {
                                try await comicModel.fetchData() // Fetch new comic data
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .onChange(of: scroll) { _ in // If scroll is triggered, go back on top of the ScrollView
                withAnimation(.spring()) {
                    proxy.scrollTo(0)
                }
            }
        }
        .task { // This is like onAppear, but for background tasks
            do {
                try await comicModel.fetchData()
            } catch {
                print(error)
            }
        }
    }
}

struct PullToRefresh: View { // This view holds a pull to refresh fanctionality, but reversed
    @EnvironmentObject var comicModel: ComicModel
    
    let action: () -> Void // Action to trigger when the user scrolls enough
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                if geo.frame(in: .global).midY < UIScreen.main.bounds.height - 220 || comicModel.isLoading { // Show a ProgressView if the user scrolls down enough or if the model is already running a request
                    ProgressView()
                        .padding(.bottom, 150)
                        .onAppear {
                            if geo.frame(in: .global).midY < UIScreen.main.bounds.height - 220 { // Trigger the action if the user scrolls down enough only
                                action()
                            }
                        }
                } else {
                    VStack { // Little tip
                        Image(systemName: "arrow.up")
                        Text("Keep going to load more")
                    }
                    .font(.callout)
                    .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.top)
        }
    }
}
