//
//  ContentView.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var comicModel: ComicModel
    @EnvironmentObject var navController: NavController
    
    @Namespace var comicExpandID: Namespace.ID // Matched geometry animations for comic images will occur inside this namespace
    
    @State var scroll: Bool = false // When this toggles, it will scroll your comic list to the top, pretty handy right?
    
    var body: some View {
        FeedView(scroll: $scroll, id: comicExpandID) // The feed view will always be present
            .toolbar { // Use a bottom bar for navigation and other actions
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomBarView(scroll: $scroll)
                }
            }
            .background(Color("backgroundColor")) // Use XKCD's ugly background color
            .overlay { // The overlay will present the selected comic's details
                if navController.current == .details {
                    ComicDetailsView(comic: comicModel.comics[navController.selectedComic], id: comicExpandID)
                }
            }
    }
}
