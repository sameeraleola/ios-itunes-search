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
    
    // MARK: - :: Create Network Session ::
    
    func performSearch(with searchTerm: String, resultType: ResultType, completion: @escaping (NSError?) -> Void) {
        
        // Create a variable to store the full request url
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //Create the necessary iTuners query parameters:
        let queryParameterSearchTerm = URLQueryItem(name: "term", value: searchTerm)
        let queryParameterCountry = URLQueryItem(name: "country", value: "US")
        let queryParameterEntity = URLQueryItem(name: "entity", value: resultType.rawValue)
        let queryParameterLimit = URLQueryItem(name: "limit", value: "20")
        let queryParameterLang = URLQueryItem(name: "lang", value: "en_us")
        
        // Create the url components
        urlComponents?.queryItems = [queryParameterSearchTerm, queryParameterCountry, queryParameterEntity, queryParameterLimit, queryParameterLang]
        
        // Now create the request url tht will be sent to iTunes
        guard let requestURL = urlComponents?.url else {
            NSLog("Unable to make iTunes search request URL")
            completion(NSError())
            return
        }
        
        // MARK: URLSession
        
        // A successful request URL has been created, now specify the REST request method: GET
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // Initiate the URLSession datatask and going to iTunes, be right back with some data...
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
            }
            
            // No error so try and unwrap the data
            guard let data = data else {
                NSLog("No data returned from data task")
                return
            }
            
            // MARK: Decode JSON
            
            // Retrieved data. Set up a JSON decoder
            let jsonDecoder = JSONDecoder()
            
            // Now let's decode the data
            do {
                let decodedSessionData = try jsonDecoder.decode(SearchResult.self, from: data)
                self.searchResults.append(decodedSessionData)
            } catch {
                NSLog("Unable to decode iTunes data into type [SearchResult]: \(error)")
            }
            completion(nil)
        } .resume() // Start network session
    } // End of network request
    
}
