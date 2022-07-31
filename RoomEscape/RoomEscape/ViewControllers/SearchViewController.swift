//
//  SearchViewController.swift
//  RoomEscape
//
//  Created by KiWoong Hong on 2022/07/26.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var themeSearchButton: UIButton!
    let roomData = JSONDataManager().roomData
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SearchResultViewController") as? SearchResultViewController
        let searchController = UISearchController(searchResultsController: viewController)
        
        title = "어디갈래"
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "원하는 방탈출을 찾아보세요"
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        let vc = searchController.searchResultsController as? SearchResultViewController
        var result: [RoomModel] = []
        
        for item in roomData {
            if item.title.uppercased().contains(text.uppercased()) {
                result.append(item)
            }
        }
        
        if result.count > 0 {
            vc?.searchLabel.text = "'\(text)'에 대한 테마를 찾았어요!"
        } else {
            vc?.searchLabel.text = "'\(text)'에 대한 테마를 찾지 못했어요!"
        }
        vc?.update(newResult: result)
    }
    
    @IBAction func themeSearchButtonPressed(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "SearchDetailRef") as? SearchDetailViewController else { return }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
