//
//  MakeTeamViewController.swift
//  RoomEscape
//
//  Created by Wonhyuk Choi on 2022/07/20.
//

import UIKit

enum EditorMode {
    case new
    case edit(Int)
}

class MakeTeamViewController: UIViewController {
    
    @IBOutlet weak var teamNameField: CustomTextField!
    @IBOutlet weak var makeButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var highlight: UIView!
    
    var editorMode: EditorMode = .new
    
    var teams = [TeamModel]() {
        didSet {
            self.saveTeams()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teamNameField.delegate = self
        self.makeButton.backgroundColor = UIColor.titleBlack
        self.makeButton.layer.cornerRadius = 10
        
        self.teamNameField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        switch self.editorMode {
        case let .edit(index):
            self.teamNameField.text = teams[index].teamName
            self.makeButton.setTitle("수정하기", for: .normal)
            firstLabel.text = "컬렉션 이름을"
            secondLabel.text = "수정해주세요!"
        default:
            break
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

    @objc func textFieldDidChange(sender: UITextField) {
        if sender.hasText {
            makeButton.backgroundColor = UIColor.mainPurple
            
        } else {
            makeButton.backgroundColor = UIColor.titleBlack
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        teamNameField.resignFirstResponder()
    }
    
    @IBAction func makeButtonTapped(_ sender: UIButton) {
        if makeButton.tintColor == UIColor.mainPurple {
            guard let teamName = self.teamNameField.text else { return }
            switch self.editorMode {
            case let .edit(index):
                teams[index].teamName = teamName
            default:
                let team = TeamModel(teamName: teamName, themeList: [Int]())
                self.teams.append(team)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension MakeTeamViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

class CustomTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = UIColor(rgb: 0x8E8E93)
            }
        }
    }
}
