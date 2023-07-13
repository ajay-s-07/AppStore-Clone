//
//  SearchResult.swift
//  AppStore
//
//  Created by Ajay Sarkate on 04/07/23.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}
struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String // app icon
    
    var formattedPrice: String?
    let description: String
    var releaseNotes: String?
}
