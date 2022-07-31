//
//  SearchDetailViewController.swift
//  RoomEscape
//
//  Created by Hyeon-sang Lee on 2022/07/26.
//

import UIKit

class SearchDetailViewController: UIViewController {

    @IBOutlet weak var locationPulldownButton: UIButton!
    @IBOutlet weak var difficultyPulldownButton: UIButton!
    @IBOutlet weak var genrePulldownButton: UIButton!
    @IBOutlet weak var companionPulldownButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var selectedLocation: String = ""
    var selectedDifficulty: String = ""
    var selectedGenre: String = ""
    var selectedCompanion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pulldown buttons setting
        configurePulldownButtons()
        
        // Button status setting
        configureSearchButtonStatus()
    }
    
    private func configureSearchButtonStatus() {
        if locationPulldownButton.currentTitle! == "지역",
           difficultyPulldownButton.currentTitle! == "난이도",
           genrePulldownButton.currentTitle! == "어떤",
           companionPulldownButton.currentTitle! == "누구와" {
            searchButton.backgroundColor = .titleBlack
            searchButton.tintColor = .titleDarkGray
            searchButton.isEnabled = false
        }

        if locationPulldownButton.currentTitle! != "지역",
           difficultyPulldownButton.currentTitle! != "난이도",
           genrePulldownButton.currentTitle! != "어떤",
           companionPulldownButton.currentTitle! != "누구와" {
            searchButton.backgroundColor = .mainPurple
            searchButton.tintColor = .titleWhite
            searchButton.isEnabled = true
        }
    }
    
    private func configurePulldownButtons() {
        // Location pulldown button setting
        let locationButton1 = UIAction(title: "경주시") { _ in self.changeLocation(with: "경주시") }
        let locationButton2 = UIAction(title: "대구광역시") { _ in self.changeLocation(with: "대구광역시") }
        let locationButton3 = UIAction(title: "포항시") { _ in self.changeLocation(with: "포항시") }
        locationButton1.state = .off
        locationButton2.state = .off
        locationButton3.state = .off
        
        let locationButtonMenu = UIMenu(children: [locationButton1, locationButton2, locationButton3])
        
        locationPulldownButton.showsMenuAsPrimaryAction = true
        locationPulldownButton.imageView?.tintColor = .titleDarkGray
        locationPulldownButton.menu = locationButtonMenu
        
        // Difficulty pulldown button setting
        let difficultyButton1 = UIAction(title: "쉬운 (1~2)") { _ in self.changeDifficulty(with: "쉬운 (1~2)") }
        let difficultyButton2 = UIAction(title: "보통 (3~4)") { _ in self.changeDifficulty(with: "보통 (3~4)") }
        let difficultyButton3 = UIAction(title: "어려움 (5)") { _ in self.changeDifficulty(with: "어려움 (5)") }
        let difficultyButtonMenu = UIMenu(children: [difficultyButton1, difficultyButton2, difficultyButton3])
        difficultyPulldownButton.showsMenuAsPrimaryAction = true
        difficultyPulldownButton.imageView?.tintColor = .titleDarkGray
        difficultyPulldownButton.menu = difficultyButtonMenu

        // Genre pulldown button setting
        let genreButton1 = UIAction(title: "감성") { _ in self.changeGenre(with: "감성") }
        let genreButton2 = UIAction(title: "공포") { _ in self.changeGenre(with: "공포") }
        let genreButton3 = UIAction(title: "스릴러") { _ in self.changeGenre(with: "스릴러") }
        let genreButton4 = UIAction(title: "추리") { _ in self.changeGenre(with: "추리") }
        let genreButton5 = UIAction(title: "판타지") { _ in self.changeGenre(with: "판타지") }
        let genreButtonMenu = UIMenu(children: [genreButton1, genreButton2, genreButton3, genreButton4, genreButton5])
        genrePulldownButton.showsMenuAsPrimaryAction = true
        genrePulldownButton.imageView?.tintColor = .titleDarkGray
        genrePulldownButton.menu = genreButtonMenu
        
        // Companion pulldown button setting
        let companionButton1 = UIAction(title: "친구와") { _ in self.changeCompanion(with: "친구") }
        let companionButton2 = UIAction(title: "연인과") { _ in self.changeCompanion(with: "연인") }
        let companionButton3 = UIAction(title: "가족과") { _ in self.changeCompanion(with: "가족") }
        let companionButtonMenu = UIMenu(children: [companionButton1, companionButton2, companionButton3])
        companionPulldownButton.showsMenuAsPrimaryAction = true
        companionPulldownButton.imageView?.tintColor = .titleDarkGray
        companionPulldownButton.menu = companionButtonMenu
        
        // Set default title for each pulldown button
        locationPulldownButton.setTitle("지역", for: .normal)
        difficultyPulldownButton.setTitle("난이도", for: .normal)
        genrePulldownButton.setTitle("어떤", for: .normal)
        companionPulldownButton.setTitle("누구와", for: .normal)
    }
    
    private func changeLocation(with location: String) {
        selectedLocation = location
        locationPulldownButton.setTitle(location, for: .normal)
        locationPulldownButton.backgroundColor = .mainPurple
        locationPulldownButton.setTitleColor(.titleWhite, for: .normal)
        locationPulldownButton.imageView?.tintColor = .titleWhite
        configureSearchButtonStatus()
    }
    
    private func changeDifficulty(with difficulty: String) {
        selectedDifficulty = difficulty
        difficultyPulldownButton.setTitle(difficulty, for: .normal)
        difficultyPulldownButton.backgroundColor = .mainPurple
        difficultyPulldownButton.setTitleColor(.titleWhite, for: .normal)
        difficultyPulldownButton.imageView?.tintColor = .titleWhite
        configureSearchButtonStatus()
    }
    
    private func changeGenre(with genre: String) {
        selectedGenre = genre
        genrePulldownButton.setTitle(genre, for: .normal)
        genrePulldownButton.backgroundColor = .mainPurple
        genrePulldownButton.setTitleColor(.titleWhite, for: .normal)
        genrePulldownButton.imageView?.tintColor = .titleWhite
        configureSearchButtonStatus()
    }

    private func changeCompanion(with companion: String) {
        selectedCompanion = companion
        companionPulldownButton.setTitle(companion, for: .normal)
        companionPulldownButton.backgroundColor = .mainPurple
        companionPulldownButton.setTitleColor(.titleWhite, for: .normal)
        companionPulldownButton.imageView?.tintColor = .titleWhite
        configureSearchButtonStatus()
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "SearchDetailResultRef") as? SearchDetailResultViewController else { return }

        viewController.selectedLocation = selectedLocation
        viewController.selectedDifficulty = selectedDifficulty
        viewController.selectedTheme = selectedGenre
        viewController.selectedWith = selectedCompanion

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}// SearchDetailViewController
