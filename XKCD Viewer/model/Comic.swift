//
//  Comic.swift
//  XKCD Viewer
//
//  Created by Nicolas Mariniello on 15/05/22.
//

import SwiftUI

struct Comic: Codable { // This structure holds a comic's data
    let month: String
    let num: Int
    let link: String
    let year: String
    let news: String
    let safe_title: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String
    
    var data: Data = Data() // Non-decoded data
    var imgView: Image? = nil // View that holds the image
    var isFavourite: Bool = false // IDK, the name of this property is really not explanatory
    
    private enum CodingKeys: String, CodingKey { // data, imgView and isFavourite are not involved in the decode process
        case month, num, link, year, news, safe_title, transcript, alt, img, title, day
    }
    
    mutating func favourite() { // This function changes the favourite state of the comic
        if isFavourite {
            isFavourite = false
            
            var favourites: [Data] = UserDefaults.standard.array(forKey: "favourites") as? [Data] ?? [] // Take the favourites array from the UserDefaults
            favourites.removeAll(where: { element in element == data }) // Remove the comic's data from the array
            
            UserDefaults.standard.set(favourites, forKey: "favourites") // Update the favourites array inside the UserDefaults
            UserDefaults.standard.removeObject(forKey: "\(num)") // Remove the comic image from the UserDefaults
        } else {
            isFavourite = true
            
            var favourites: [Data] = UserDefaults.standard.array(forKey: "favourites") as? [Data] ?? []
            favourites.append(data) // Append the comic's data to the favourites array
            
            let encodedImg = try! PropertyListEncoder().encode(imgView?.snapshot().pngData()) // Encode the comic's image
            print("ciao")
            
            UserDefaults.standard.set(favourites, forKey: "favourites")
            UserDefaults.standard.set(encodedImg, forKey: "\(num)") // Insert the encoded comic's image inside the UserDefaults
        }
    }
}
