//
//  XKCD_ViewerApp.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

@main
struct XKCD_TestApp: App {
    @StateObject var comicModel: ComicModel = ComicModel() // This is the model that will manage the data and tell the UI when to update its state
    @StateObject var navController: NavController = NavController() // This implements a custom UI navigation I felt like building for minimallism and modernity
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(comicModel) // Push the model as an environmental object, it will be available to all subviews of ContentView
                .environmentObject(navController) // Do the same for the navigation controller
                .preferredColorScheme(.light) // Prefer light theme, I chose not to focus on dark theme for now
        }
    }
}
