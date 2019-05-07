//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Sameera Roussi on 5/7/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let title: String
    let creator: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case  creator = "artistName"
    }
}

struct SearchResults: Decodable {
    let results: [SearchResult]
}
