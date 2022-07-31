//
//  PickViewController.swift
//  RoomEscape
//
//  Created by Wonhyuk Choi on 2022/07/18.
//

import UIKit

class PickViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var teams = [TeamModel]() {
        didSet {
            self.saveTeams()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTeams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTeams()
        self.tableView.reloadData()
    }
    
    func loadTeams() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "teams") as? [[String: Any]] else { return }
        self.teams = data.compactMap {
            guard let title = $0["teamName"] as? String else { return nil }
            guard let themeList = $0["themeList"] as? [Int] else { return nil }
            return TeamModel(teamName: title, themeList: themeList)
        }
    }
    
    func saveTeams() {
        let data = self.teams.map {
            [
                "teamName": $0.teamName,
                "themeList": $0.themeList
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "teams")
    }
    
    func deleteTeams(_ index: Int) {
        let sheet = UIAlertController(title: "팀 삭제", message: "팀을 삭제하겠습니까?", preferredStyle: .alert)
        
        sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.teams.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.tableView.reloadData()
        }))
                
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil ))
        
        present(sheet, animated: true)
    }
}

extension PickViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamCell else { return UITableViewCell() }
        
        if indexPath.row == teams.count {
            cell.teamName.text = ""
            cell.descriptionLabel.text = ""
            cell.addImage.image = UIImage(systemName: "plus")
            cell.addLabel.text = "테마 컬렉션 만들기"
            cell.gearIcon.isHidden = true
        } else {
            cell.teamName.text = teams[indexPath.row].teamName
            cell.descriptionLabel.text = "\(teams[indexPath.row].themeList.count)개의 방탈출 테마"
            cell.addImage.image = .none
            cell.addLabel.text = ""
            cell.gearIcon.isHidden = false
            cell.gearIcon.tag = indexPath.row
            cell.gearIcon.addTarget(self, action: #selector(gearTapped(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func gearTapped(sender: UIButton) {
        let alert = UIAlertController(title: "팀 편집", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "팀 이름 수정", style: .default , handler:{ (UIAlertAction) in
            guard let viewController = self.storyboard?.instantiateViewController(identifier: "MakeTeamViewController") as? MakeTeamViewController else { return }
            viewController.teams = self.teams
            viewController.editorMode = .edit(sender.tag)
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "팀 삭제", style: .destructive , handler:{ (UIAlertAction) in
            self.deleteTeams(sender.tag)
        }))
        
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil ))
        
        self.present(alert, animated: true)
    }
}

extension PickViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == teams.count {
            guard let viewController = self.storyboard?.instantiateViewController(identifier: "MakeTeamViewController") as? MakeTeamViewController else { return }
            viewController.teams = self.teams
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            guard let viewController = self.storyboard?.instantiateViewController(identifier: "TeamViewControllerRef") as? TeamViewController else { return }
            let team = self.teams[indexPath.row]
            viewController.team = team
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
