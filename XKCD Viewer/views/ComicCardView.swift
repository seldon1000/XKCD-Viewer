//
//  ComicCardView.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

struct ComicCardView: View {
    @EnvironmentObject var comicModel: ComicModel
    @EnvironmentObject var navController: NavController
    
    let comic: Int
    let id: Namespace.ID
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16) // Card background
                .stroke(Color.black, lineWidth: 2)
                .background {
                    Color.white
                        .cornerRadius(16)
                }
            if comicModel.comics[comic].imgView != nil { // Check if the comic image is already in memory
                VStack {
                    comicModel.comics[comic].imgView!
                        .resizable()
                        .scaledToFit()
                        .matchedGeometryEffect(id: "image\(comicModel.comics[comic].num)", in: id) // Animate the changes when the user taps on the card
                        .onTapGesture {
                            navController.selectedComic = comic // Save the selcted comic's index
                            
                            withAnimation(.spring()) {
                                navController.navigate(to: .details) // Navigate to the comic's details overlay
                            }
                        }
                    Text(comicModel.comics[comic].title)
                    Text("#\(comicModel.comics[comic].num) | \(comicModel.comics[comic].year).\(comicModel.comics[comic].month).\(comicModel.comics[comic].day)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            } else { // If the image is not yet in memory, use an AsyncImage to load it in background
                AsyncImage(url: URL(string: comicModel.comics[comic].img)!) { image in
                    VStack {
                        image
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "image\(comicModel.comics[comic].num)", in: id)
                            .onTapGesture {
                                comicModel.comics[comic].imgView = image // When the image is fully loaded, save it in comic's memory
                                navController.selectedComic = comic
                                
                                withAnimation(.spring()) {
                                    navController.navigate(to: .details)
                                }
                            }
                        Text(comicModel.comics[comic].title)
                        Text("#\(comicModel.comics[comic].num) | \(comicModel.comics[comic].year).\(comicModel.comics[comic].month).\(comicModel.comics[comic].day)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } placeholder: {
                    Image("xkcdPlaceholder") // Show a nice placeholder while the image is loading in the background
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
