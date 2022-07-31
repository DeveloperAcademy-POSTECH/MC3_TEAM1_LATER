//
//  TeamViewController.swift
//  RoomEscape
//
//  Created by Noah's Ark on 2022/07/20.
//

import UIKit

enum ViewMode {
    case standard
    case compare
    case edit
}

class TeamViewController: UIViewController {
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var themeComparisonButton: UIButton!
    @IBOutlet weak var themeComparisonView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emptyLabel: UIStackView!
    @IBOutlet weak var emptyButton: UIButton!
    
    let roomDataManager = JSONDataManager.shared
    
    let util: Util = Util()
    var selectedThemes: [Int] = []
    var viewMode: ViewMode = .standard
    var team: TeamModel?
    
    var cancelButton : UIBarButtonItem?
    var shareButton : UIBarButtonItem?
    var editButton : UIBarButtonItem?
    var deleteButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        cancelButton = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped)
        )
        editButton = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(editButtonTapped)
        )
        deleteButton = UIBarButtonItem(
            title: "삭제",
            style: .plain,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        
        self.configureView()
        
        themeComparisonView.layer.cornerRadius = 5
        themeComparisonButton.layer.cornerRadius = 10
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        teamTableView.register(UINib(nibName: Constants.roomTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.roomTableViewCell)
        teamTableView.register(UINib(nibName: Constants.roomSelectionTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.roomSelectionTableViewCell)
        teamTableView.allowsMultipleSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if team?.themeList.isEmpty ?? true {
            teamTableView.isHidden = true
            themeComparisonView.isHidden = true
            emptyLabel.isHidden = false
            emptyButton.isHidden = false
        } else {
            teamTableView.isHidden = false
            themeComparisonView.isHidden = false
            emptyLabel.isHidden = true
            emptyButton.isHidden = true
            navigationItem.rightBarButtonItems = [ self.editButton!, self.shareButton!]
        }
        
        teamTableView.reloadData()
    }
    
    private func configureView() {
        guard let team = self.team else { return }
        self.teamNameLabel.text = team.teamName
    }
    
    // Make the themeComparisonView disappear when this button is pressed
    @IBAction func themeComparisonButtonPressed(_ sender: UIButton) {
        switch viewMode {
        case .standard:
            teamTableView.allowsMultipleSelection = true
            navigationItem.rightBarButtonItems = [ self.cancelButton!]
            self.viewMode = .compare
            self.themeComparisonButton.setTitle("비교하기", for: .normal)
            self.themeComparisonButton.backgroundColor = UIColor.titleBlack
            self.infoLabel.text = "원하는 2개의 테마를 비교해요!"
            self.teamTableView.reloadData()
        case .compare:
            if themeComparisonButton.backgroundColor == UIColor.mainPurple {
                guard let viewController = self.storyboard?.instantiateViewController(identifier: "ThemeCompareViewControllerRef") as? ThemeCompareViewController else { return }
                
                viewController.firstTheme = roomDataManager.roomData[selectedThemes[0]]
                viewController.secondTheme = roomDataManager.roomData[selectedThemes[1]]
                
                self.navigationController?.pushViewController(viewController, animated: true)
                
                teamTableView.allowsMultipleSelection = false
                self.viewMode = .standard
                self.themeComparisonButton.isHidden = false
                self.themeComparisonButton.setTitle("테마 비교", for: .normal)
                self.themeComparisonButton.backgroundColor = UIColor.mainPurple
                self.infoLabel.text = "테마간 차이점이 궁금하다면?"
                selectedThemes.removeAll()
                self.teamTableView.reloadData()
            }
        case .edit:
            break
        }
    }
    
    @objc func cancelButtonTapped() {
        navigationItem.rightBarButtonItems = [ self.editButton!, self.shareButton!]
        teamTableView.allowsMultipleSelection = false
        self.viewMode = .standard
        self.themeComparisonButton.isHidden = false
        self.themeComparisonButton.setTitle("테마 비교", for: .normal)
        self.themeComparisonButton.backgroundColor = UIColor.mainPurple
        self.infoLabel.text = "테마간 차이점이 궁금하다면?"
        selectedThemes.removeAll()
        self.teamTableView.reloadData()
    }
    
    @objc func shareButtonTapped() {
        guard let teamInfo = self.team else { return }
        
        let rooms = teamInfo.themeList.map { roomDataManager.roomData[$0] }
        let images = rooms.map { (room) -> UIImage in
            if let url = URL(string: room.image) {
                if let data = try? Data(contentsOf: url ) {
                    return UIImage(data: data)!
                } else {
                    return UIImage(systemName: "house")!
                }
            } else {
                return UIImage(systemName: "house")!
            }
        }
        
        // image to share
        let image = ShareScreenShotView(
            forWhom: teamInfo.teamName,
            rooms: rooms,
            images: images
        ).asUiImage()
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped() {
        navigationItem.rightBarButtonItems = [ self.deleteButton!, self.cancelButton!, ]
        teamTableView.allowsMultipleSelection = true
        self.viewMode = .edit
        self.themeComparisonButton.isHidden = true
        self.infoLabel.text = "삭제하고 싶은 테마를 삭제하세요"
        self.teamTableView.reloadData()
    }
    
    @objc func deleteButtonTapped() {
        let sheet = UIAlertController(title: "테마 삭제", message: "정말 삭제하겠습니까?", preferredStyle: .alert)
        
        sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            guard let preThemes = self.team?.themeList else { return }
            let curThemes = Array(Set(preThemes).subtracting(Set(self.selectedThemes)))
            
            let userDefaults = UserDefaults.standard
            guard let tmpData = userDefaults.object(forKey: "teams") as? [[String: Any]] else { return }
            var teams : [TeamModel] = tmpData.compactMap {
                guard let title = $0["teamName"] as? String else { return nil }
                guard let themeList = $0["themeList"] as? [Int] else { return nil }
                return TeamModel(teamName: title, themeList: themeList)
            }
            guard let index = teams.firstIndex(where: {$0.teamName == self.team?.teamName }) else { return }
            teams.remove(at: index)
            let newTeam = TeamModel(teamName: self.team?.teamName ?? "", themeList: curThemes)
            teams.append(newTeam)
            let data = teams.map {
                [
                    "teamName": $0.teamName,
                    "themeList": $0.themeList
                ]
            }
            userDefaults.set(data, forKey: "teams")
            
            self.team?.themeList = curThemes
            
            self.navigationItem.rightBarButtonItems = [ self.editButton!, self.shareButton!]
            self.teamTableView.allowsMultipleSelection = false
            self.viewMode = .standard
            self.themeComparisonButton.isHidden = false
            self.themeComparisonButton.setTitle("테마 비교", for: .normal)
            self.themeComparisonButton.backgroundColor = UIColor.mainPurple
            self.infoLabel.text = "테마간 차이점이 궁금하다면?"
            self.selectedThemes.removeAll()
            self.teamTableView.reloadData()
        }))
                
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil ))
        
        present(sheet, animated: true)
    }
    
    @IBAction func findThemeButtonTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
}// TeamViewController

// MARK: UITableViewDelegate, UITableViewDataSource
extension TeamViewController: UITableViewDelegate {
    // 터치가 비활성화 되었을 경우
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch viewMode {
        case .compare, .edit:
            guard let theme = team?.themeList[indexPath.row] else { return }
            selectedThemes = selectedThemes.filter { $0 != theme }
            self.themeComparisonButton.backgroundColor = UIColor.titleBlack
        default:
            break
        }
    }
    
    // 터치가 활성화 되었을 경우
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewMode {
        case .standard:
            guard let viewController = self.storyboard?.instantiateViewController(identifier: "DetailViewControllerRef") as? DetailViewController else { return }
            
            guard let theme = team?.themeList[indexPath.row] else { return }
            viewController.roomIndex = theme
            
            self.navigationController?.pushViewController(viewController, animated: true)
        case .compare:
            guard selectedThemes.count < 2 else {
                util.showToast(view: self.view, message: "2개 이상 선택할 수 없습니다")
                self.teamTableView.reloadRows(at: [indexPath], with: .automatic)
                return
            }
            guard let theme = team?.themeList[indexPath.row] else { return }
            selectedThemes.append(theme)
            if selectedThemes.count == 2 {
                self.themeComparisonButton.backgroundColor = UIColor.mainPurple
            }
        case .edit:
            guard let theme = team?.themeList[indexPath.row] else { return }
            selectedThemes.append(theme)
        }
    }
}

extension TeamViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let themes = self.team?.themeList else { return 0 }

        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewMode {
        case .edit, .compare:
            let selectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.roomSelectionTableViewCell, for: indexPath) as! RoomSelectionTableViewCell
            
            let themes = self.team?.themeList
            guard let themeIdx = themes?[indexPath.row] else { return UITableViewCell() }
            let roomInfo = roomDataManager.roomData[themeIdx]
            
            selectionCell.roomName?.text = roomInfo.title
            let url = URL(string: roomInfo.image)
            selectionCell.storeName?.text = roomInfo.storeName
            selectionCell.genre.text = roomInfo.genre
            selectionCell.roomImage?.contentMode = .scaleToFill
            selectionCell.roomImage?.clipsToBounds = true
            
            for i in 0 ..< roomInfo.difficulty {
                selectionCell.difficulties?.arrangedSubviews[i].tintColor = UIColor(named: "star");
            }
            
            DispatchQueue.main.async {
                if let url = url {
                    if let data = try? Data(contentsOf: url) {
                        selectionCell.roomImage?.image = UIImage(data: data)
                    } else {
                        selectionCell.roomImage?.image = UIImage(named: "noRoom")
                    }
                }
            }
            
            return selectionCell
        case .standard:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.roomTableViewCell, for: indexPath) as! RoomTableViewCell
            
            let themes = self.team?.themeList
            guard let themeIdx = themes?[indexPath.row] else { return UITableViewCell() }
            let roomInfo = roomDataManager.roomData[themeIdx]
            
            cell.roomName?.text = roomInfo.title
            let url = URL(string: roomInfo.image)
            cell.storeName?.text = roomInfo.storeName
            cell.genre.text = roomInfo.genre
            cell.roomImage?.contentMode = .scaleToFill
            cell.roomImage?.clipsToBounds = true
            
            for i in 0 ..< roomInfo.difficulty {
                cell.difficulties?.arrangedSubviews[i].tintColor = UIColor(named: "star");
            }
            
            DispatchQueue.main.async {
                if let url = url {
                    if let data = try? Data(contentsOf: url) {
                        cell.roomImage?.image = UIImage(data: data)
                    } else {
                        cell.roomImage?.image = UIImage(systemName: "house")
                    }
                }
            }
            return cell
        }
    }
    
}
