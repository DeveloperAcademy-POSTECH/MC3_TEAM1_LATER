//
//  SearchResultViewController.swift
//  RoomEscape
//
//  Created by KiWoong Hong on 2022/07/27.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var resultRooms: [RoomModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableViewCellNib = UINib(nibName: Constants.roomTableViewCell, bundle: nil)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: Constants.roomTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func update(newResult: [RoomModel]) {
        if resultRooms == newResult {
        } else {
            resultRooms = newResult
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoomTableViewCell else { return }
        guard let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewControllerRef") as? DetailViewController else { return }

        detailViewController.roomIndex = cell.index - 1

//        self.present(detailViewController, animated: true)
        self.presentingViewController?.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell", for: indexPath) as? RoomTableViewCell else { return UITableViewCell() }
        
        let roomInfo = resultRooms[indexPath.row]
        let url = URL(string: roomInfo.image)
        
        cell.roomName?.text = roomInfo.title
        cell.storeName?.text = roomInfo.storeName
        cell.genre.text = roomInfo.genre
        cell.roomImage?.contentMode = .scaleToFill
        cell.roomImage?.clipsToBounds = true
        cell.index = roomInfo.id
        
        for i in 0 ..< 5{
            if i < roomInfo.difficulty {
                cell.difficulties?.subviews[i].tintColor = UIColor(named: "star")
            } else {
                cell.difficulties?.subviews[i].tintColor = UIColor.titleBlack
            }
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
