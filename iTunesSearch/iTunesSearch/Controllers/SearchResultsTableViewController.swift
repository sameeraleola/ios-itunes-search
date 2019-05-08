//
//  SearchResultsTableViewController.swift
//  iTunesSearch
//
//  Created by Sameera Roussi on 5/8/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    let reuseIdentifier = "TitleCell"
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchResultsController = SearchResultController()
    
    
    // MARK: - Table view states

    override func viewDidLoad() {
        super.viewDidLoad()

        //searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultsController.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        let searchResult = searchResultsController.searchResults[indexPath.row]
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.creator

        return cell
    }

    // MARK: - Search bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var mediaType: ResultType!
        
        // Get the search term from the search bar
        guard let searchTerm = searchBar.text else { return }
        
        // Get the media type to be retrieved
        let segmentSelected = segmentControl.selectedSegmentIndex
        
        // Set the resultType based on the segment selected
        switch segmentSelected {
            case 0:
                mediaType = ResultType.software
            case 1:
                mediaType = ResultType.musicTrack
            case 2:
                mediaType = ResultType.movie
            default:
                mediaType = ResultType.software
        }
        
        // Produce the url request string
        searchResultsController.performSearch(with: searchTerm, resultType: mediaType) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
