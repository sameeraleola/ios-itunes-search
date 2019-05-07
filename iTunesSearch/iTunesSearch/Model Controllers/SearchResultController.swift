//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Sameera Roussi on 5/7/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation

class SearchResultController {
    
    // MARK: - Properties
    
    // Create a enum type of the REST methods. Only need GET, but let's make good habits
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    let baseURL = URL(string: "https://itunes.apple.com")!
    var searchResults: [SearchResult] = []
    
    // MARK: - URLSession
    
    func performSearch(with searchTerm: String, resultType: ResultType, completion: @escaping (NSError?) -> Void) {
        
        // Create a variable to store the full request url
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //Create the necessary iTuners query parameters:
        let queryParameterSearchTerm = URLQueryItem(name: "term", value: searchTerm)
        let queryParameterCountry = URLQueryItem(name: "country", value: "US")
        let queryParameterEntity = URLQueryItem(name: "entity", value: resultType.rawValue)
        let queryParameterLimit = URLQueryItem(name: "limit", value: "20")
        let queryParameterLang = URLQueryItem(name: "lang", value: "en_us")
        
        // Create the url components
        components?.queryItems = [queryParameterSearchTerm, queryParameterCountry, queryParameterEntity, queryParameterLimit, queryParameterLang]
        
        // Now create the request url tht will be sent to iTunes
        guard let requestURL = components?.url else {
            NSLog("requestURL is nil")
            completion(NSError())
            return
        }
        
        // A successful request URL has been created, now specify the REST request method: GET
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // Initiate the URLSession datatask and going to iTunes, be right back with some data...
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            // Unable to query the API so log the error and return
            if let error = error {
                NSLog("Error fetching data from iTunes API: \(error)")
                return
            }
            
            // The request was successful, let's check the data
            guard let data = data else {
                NSLog("No data returned from datatask")
            }
        }
        
        //
        
    }
}


// let searchTermQueryItem = URLQueryItem(name: "search", value: searchTerm)
