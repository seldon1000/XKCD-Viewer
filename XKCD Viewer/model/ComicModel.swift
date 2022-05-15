//
//  ComicModel.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

enum ComicsSort { // Enum type for comic sort
    case ascendent
    case descendent
}

class ComicModel: ObservableObject {
    @Published var comics: [Comic] = [] // Array that holds all the comics loaded from the web
    private(set) var isLoading: Bool = true // Sort of "mutex": this will grant that no request are done if another is still running
    
    private var sort: ComicsSort = .ascendent // This holds the selected sort order
    
    init() { // Model initializer
        let favouritesData: [Data] = UserDefaults.standard.array(forKey: "favourites") as? [Data] ?? [] // Load the array of favourites from the UserDefaults
        
        for data in favouritesData { // Iterate through the favourites array
            do {
                var favourite: Comic = try JSONDecoder().decode(Comic.self, from: data) // The uSerDefaults hold the favourite data, so decode it
                favourite.isFavourite = true // Favourite the favourite
                favourite.data = data // Save its data in memory
                favourite.imgView = Image(uiImage: UIImage(data: try! PropertyListDecoder().decode(Data.self, from: UserDefaults.standard.data(forKey: "\(favourite.num)")!))!) // The UserDefaults also hold the full comic image, so that an internet connection is not required to retrive it
                
                comics.insert(favourite, at: comics.firstIndex(where: { sort == .ascendent ? $0.num > favourite.num : $0.num <= favourite.num }) ?? comics.endIndex) // Insert the favourite inside the comics list
            } catch {
                print(error) // Print the error, if any (kinda lazy and boring)
            }
        }
        
        Task { // Now, the initializer starts loading the today's feature comic inside a background task
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://xkcd.com/info.0.json")!)) // Load data with an http request
            
            guard (response as! HTTPURLResponse).statusCode == 200 else { // Assert the request went all good
                print("Something went wrong")
                
                return
            }
            
            var comic: Comic = try JSONDecoder().decode(Comic.self, from: data) // Decode comic's data
            comic.data = data // Save the comic's data
            
            DispatchQueue.main.async { [self, comic] in // Move on to the main thread so that UI updates can be triggered as expected
                var isFavourite: Bool = false
                
                if let index = comics.firstIndex(where: { element in element.num == comic.num }) { // If the today's feature comic is already in the list, it means it's a favourite
                    isFavourite = true
                    
                    comics.remove(at: index)
                }
                
                comics.insert(comic, at: 0) // Insert the today's feature as the first comic of the list, always
                comics[0].isFavourite = isFavourite
                
                isLoading = false // Allow new requests
            }
        }
    }
    
    func fetchData() async throws { // This function fetches data from XKCD, retrieving 10 comics at time
        if !isLoading { // Be sure there are no other requests pending
            isLoading = true // Lock other requests
            
            var newComics: [Comic] = comics // Use a temporary copy of the comics list, so that no UI updates will be triggereed during the process
            newComics.remove(at: 0) // Remove the today's feature comic so that it isn't involved in the process
            
            for num in stride(from: sort == .ascendent ? comics.count : comics[0].num - comics.last!.num, to: sort == .ascendent ? comics.count + 10 : comics[0].num - comics.last!.num - 10, by: sort == .ascendent ? 1 : -1) { // Now, if the sort order is ascendent, look for the next 10 comics (1-11, 12-22, ...), otherwise, take the today's feature comic num and start iterating from that in reverse
                let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://xkcd.com/\(num)/info.0.json")!)) // Load the comic data
                
                guard (response as! HTTPURLResponse).statusCode == 200 else {
                    print("Something went wrong")
                    
                    return
                }
                
                var comic: Comic = try JSONDecoder().decode(Comic.self, from: data)
                comic.data = data
                
                if !newComics.contains(where: { element in element.num == comic.num }) { // Do not insert the new comic ifit's already in the list
                    newComics.insert(comic, at: newComics.firstIndex(where: { sort == .ascendent ? $0.num > comic.num : $0.num <= comic.num }) ?? newComics.endIndex) // Insert the new comic inside in the correct location inside the comics list, following the selected sort order
                }
            }
            
            newComics.insert(comics[0], at: 0) // Insert the today's feature comic as first element
            
            DispatchQueue.main.async { [self, newComics] in // Move on to the main thread so that we can trigger UI updates
                comics = newComics
                
                isLoading = false
            }
        }
    }
    
    func sortComics() { // This function changes the selected sort order
        sort = sort == .ascendent ? .descendent : .ascendent
        
        var sortedComics: [Comic] = comics // Work on a temporary copy of the comics list
        sortedComics.remove(at: 0)
        sortedComics = sortedComics.reversed() // Since every new comic is always added in the correct location following the selected sort order, we just have to reverse the array
        sortedComics.insert(comics[0], at: 0)
        
        comics = sortedComics // The comic array is now reversed
    }
}
