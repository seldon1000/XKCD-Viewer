//
//  ComicDetailsView.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

struct ComicDetailsView: View {
    @EnvironmentObject var navController: NavController
    
    let comic: Comic // For the first time, we use a Comic instance instead of the index. This is because this view does not change anything inside the comic, so we don't have to access the model's comics list
    let id: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                (comic.imgView != nil ? comic.imgView! : Image("xkcdPlaceholder")) // If the comic image is already loaded, show it, otherwaise show a placeholder
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: "image\(comic.num)", in: id)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            navController.popBack()
                        }
                    }
                Text("ALT") // Show the alt description
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding([.horizontal, .top])
                    .padding(.bottom, 8)
                Text(comic.alt)
                    .padding(.horizontal)
                Text("LINK") // Show the comic link
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding([.horizontal, .top])
                    .padding(.bottom, 8)
                Link(comic.img, destination: URL(string: "https://xkcd.com/\(comic.num)")!)
                    .padding([.horizontal, .bottom])
            }
        }
        .background(.white)
    }
}

extension View { // This extension allow us to take a snapshot of the view, however it is not perfect and images taken with this will look ugly
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
