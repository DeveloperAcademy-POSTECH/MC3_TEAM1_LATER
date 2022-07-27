//
//  SearchViewController.swift
//  RoomEscape
//
//  Created by KiWoong Hong on 2022/07/26.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SearchResultViewController") as? SearchResultViewController
        let searchController = UISearchController(searchResultsController: viewController)
        
        title = "테마 찾기"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
      //  let vc = searchController.searchResultsController as? SearchResultViewController
     //   vc?.view.backgroundColor = .yellow
        print(text)
    }
}