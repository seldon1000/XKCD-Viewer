//
//  BottomBarView.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

enum BottomBarMode { // Enum type for navigation, I use it to show the correct bottom bar layout and actions
    case feed // Comics feed
    case favourites // Favourites (unbelievable)
    case details // Comic deatils
}

class NavController: ObservableObject { // This manages the navigation inside the app
    @Published private(set) var current: BottomBarMode = .feed // Current navigation
    private(set) var last: BottomBarMode = .feed // Previous navigation
    var selectedComic: Int = 0 // This holds the selecte comics index when accessing its deatils
    
    func navigate(to page: BottomBarMode) { // This function lets us navigate to another page
        last = current
        current = page
    }
    
    func popBack() { // This function pops back the navigation
        current = last
    }
}

struct ShareSheet: UIViewControllerRepresentable { // This view lets us show a share sheet in SwiftUI
    let text: String // This holds the text to be shared using the sheet
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {}
}

struct BottomBarView: View {
    @EnvironmentObject var comicModel: ComicModel
    @EnvironmentObject var navController: NavController
    
    @Binding var scroll: Bool
    
    @State var isPresented: Bool = false
    
    var body: some View {
        switch navController.current { // Switch to the right bottombar layout according to the current navigation
        case .feed:
            Button { // Button to sort comics
                withAnimation(.linear) {
                    comicModel.sortComics()
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            Spacer()
            Menu { // Current page title + tap to scroll up + navigation controller
                Button {
                    navController.navigate(to: .favourites)
                } label: {
                    Text("Favourites")
                }
            } label: {
                VStack {
                    Text("Feed")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("\(comicModel.comics.count) comics loaded")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            } primaryAction: {
                scroll.toggle()
            }
            Spacer()
            Button {} label: { // NOT YET IMPLEMENTED
                Image(systemName: "magnifyingglass")
            }
        case .favourites:
            Button {
                withAnimation(.linear) {
                    comicModel.sortComics()
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            Spacer()
            Menu {
                Button {
                    navController.navigate(to: .feed)
                } label: {
                    Text("Feed")
                }
            } label: {
                    Text("Favourites")
                        .font(.headline)
                        .foregroundColor(.black)
            } primaryAction: {
                scroll.toggle()
            }
            Spacer()
            Button {} label: { // NOT YET IMPLEMENTED
                Image(systemName: "magnifyingglass")
            }
        case .details:
            Button { // Button to favourite a comic
                comicModel.comics[navController.selectedComic].favourite()
            } label: {
                Image(systemName: comicModel.comics[navController.selectedComic].isFavourite ? "heart.fill" : "heart")
            }
            Spacer()
            Menu {
                Button {
                    navController.navigate(to: .feed)
                } label: {
                    Text("Feed")
                }
                Button {
                    navController.navigate(to: .favourites)
                } label: {
                    Text("Favourites")
                }
            } label: {
                VStack {
                    Text(comicModel.comics[navController.selectedComic].title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .truncationMode(.tail)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                    Text("#\(comicModel.comics[navController.selectedComic].num) | \(comicModel.comics[navController.selectedComic].year).\(comicModel.comics[navController.selectedComic].month).\(comicModel.comics[navController.selectedComic].day)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            } primaryAction: {
                scroll.toggle()
            }
            Spacer()
            Button { // Button to share the comic
                isPresented.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .sheet(isPresented: $isPresented) {
                ShareSheet(text: "#\(comicModel.comics[navController.selectedComic].num): \(comicModel.comics[navController.selectedComic].title)\n\nAvailable on XKCD: https://xkcd.com/\(comicModel.comics[navController.selectedComic].num)")
            }
        }
    }
}
