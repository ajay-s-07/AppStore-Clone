//
//  AppGroup.swift
//  AppStore
//
//  Created by Ajay Sarkate on 06/07/23.
//

import Foundation

struct AppGroup: Decodable {
    
    let feed: Feed
    
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let name, artistName, artworkUrl100, id: String
}
