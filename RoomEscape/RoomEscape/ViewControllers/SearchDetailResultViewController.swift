//
//  SearchDetailResultViewController.swift
//  RoomEscape
//
//  Created by MINJI on 2022/07/26.
//

import UIKit

class SearchDetailResultViewController: UIViewController {
    
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var difficultyLabel : UILabel!
    @IBOutlet var themeLabel : UILabel!
    @IBOutlet var withLabel : UILabel!
    @IBOutlet weak var resultTableView: UITableView!
    
    let roomDataManager: JSONDataManager = JSONDataManager()
    var searchResultRoomModels: [RoomModel] = []
    var selectedLocation: String = ""
    var selectedDifficulty: String = ""
    var selectedTheme: String = ""
    var selectedWith: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = selectedLocation
        difficultyLabel.text = selectedDifficulty
        themeLabel.text = selectedTheme
        
        if selectedWith == "친구" {
            withLabel.text = selectedWith + "와"
        } else {
            withLabel.text = selectedWith + "과"
        }

        configureSearchResult()
        
        if searchResultRoomModels != [] {
            resultTableView.delegate = self
            resultTableView.dataSource = self
            resultTableView.register(UINib(nibName: Constants.roomTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.roomTableViewCell)
        }
        
    }
    
    private func configureSearchResult() {
        if selectedDifficulty == "쉬운(1~2)" {
            searchResultRoomModels = roomDataManager.roomData.filter { RoomModel in
                RoomModel.location == selectedLocation &&
                RoomModel.genre == selectedTheme &&
                RoomModel.difficulty == 2
            }
        } else if selectedDifficulty == "보통(3~4)" {
            searchResultRoomModels = roomDataManager.roomData.filter { RoomModel in
                RoomModel.location == selectedLocation &&
                RoomModel.genre == selectedTheme &&
                RoomModel.difficulty == 4
            }
        } else if selectedDifficulty == "어려움(5)" {
            searchResultRoomModels = roomDataManager.roomData.filter { RoomModel in
                RoomModel.location == selectedLocation &&
                RoomModel.genre == selectedTheme &&
                RoomModel.difficulty == 5
            }
        } else {
            searchResultRoomModels = roomDataManager.roomData.filter { RoomModel in
                RoomModel.location == selectedLocation &&
                RoomModel.genre == selectedTheme &&
                RoomModel.difficulty == 1
            }
        }
    }
    
}

extension SearchDetailResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoomTableViewCell else { return }
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DetailViewControllerRef") as? DetailViewController else { return }
        
        viewController.roomIndex = cell.index - 1

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchDetailResultViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultRoomModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.roomTableViewCell, for: indexPath) as! RoomTableViewCell
        let roomInfo = searchResultRoomModels[indexPath.row]
        let url = URL(string: roomInfo.image)

        cell.roomName?.text = roomInfo.title
        cell.storeName?.text = roomInfo.storeName
        cell.genre.text = roomInfo.genre
        cell.roomImage?.contentMode = .scaleToFill
        cell.roomImage?.clipsToBounds = true
        cell.index = roomInfo.id
        
        for i in 0 ..< roomInfo.difficulty {
            cell.difficulties?.arrangedSubviews[i].tintColor = UIColor(named: "star");
        }
        
        DispatchQueue.main.async {
            if let url = url {
                if let data = try? Data(contentsOf: url) {
                    cell.roomImage?.image = UIImage(data: data)
                } else {
                    cell.roomImage?.image = UIImage(named: "noRoom")
                }
            }
        }
        
        return cell
    }
}
    
