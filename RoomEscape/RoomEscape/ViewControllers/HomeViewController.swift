//
//  HomeViewController.swift
//  RoomEscape
//
//  Created by Noah's Ark on 2022/07/19.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    // IBOutlet Variables
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var currentLocationMenu: UIMenu!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentLocationHighlight: UIView!
    @IBOutlet weak var dimensionImageView: UIImageView!
    @IBOutlet weak var firstRecommendationHighlight: UIView!
    @IBOutlet weak var genreRecommendation: UILabel!
    @IBOutlet weak var genreRecommendationSecond: UILabel!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var recommendationCollectionView: UICollectionView!
    @IBOutlet weak var recommendationCollectionViewSecond: UICollectionView!
    @IBOutlet weak var secondRecommendationHighlight: UIView!
    @IBOutlet weak var allViewButton: UIButton!
    @IBOutlet weak var locationAllViewButton: UIButton!
    @IBOutlet weak var firstGenreAllViewButton: UIButton!
    @IBOutlet weak var secondGenreAllViewButton: UIButton!
    
    // Variables
    var isCurrentLocationButtonPressed: Bool = false
    var locationRoomModels: [RoomModel] = []
    var randomRoomModels: [RoomModel] = []
    var randomRoomModelsSecond: [RoomModel] = []
    let locationManager = CLLocationManager()
    let roomDataManager: JSONDataManager = JSONDataManager()
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Currnet Location Setting
        configureCurrnetLocation()

        // Random genres setting
        configureGenreRecommendation()
        
        // Delegate setting
        configureDelegateSetting()
        
        // Pull down setting
        configruePulldownButton()
        
        // Configure other settings
        dimensionImageView.image = UIImage(named: Constants.mainImageArray[Int.random(in: 0..<Constants.mainImageArray.count)])
        
    }
    
    // Handling functions
    private func configureCurrnetLocation() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func configureGenreRecommendation() {
        let introLabel: String = "테마는 어때요?"

        while randomRoomModels.isEmpty || randomRoomModelsSecond.isEmpty {

            genreRecommendation.text = Constants.genreCategories[Int.random(in: 0..<Constants.genreCategories.count)]
            genreRecommendationSecond.text = Constants.genreCategories[Int.random(in: 0..<Constants.genreCategories.count)]
        
            while genreRecommendation.text == genreRecommendationSecond.text {
                genreRecommendation.text = Constants.genreCategories[Int.random(in: 0..<Constants.genreCategories.count)]
                genreRecommendationSecond.text = Constants.genreCategories[Int.random(in: 0..<Constants.genreCategories.count)]
            }
        
            if genreRecommendation.text!.count == 2 {
                firstRecommendationHighlight.frame.size.width = 98
            } else if genreRecommendation.text!.count == 3 {
                firstRecommendationHighlight.frame.size.width = 124
            } else if genreRecommendation.text!.count == 4 {
                firstRecommendationHighlight.frame.size.width = 144
            } else if genreRecommendation.text!.count == 5 {
                firstRecommendationHighlight.frame.size.width = 154
            } else if genreRecommendation.text!.count == 7 {
                firstRecommendationHighlight.frame.size.width = 198
            }

            if genreRecommendationSecond.text!.count == 2 {
                secondRecommendationHighlight.frame.size.width = 98
            } else if genreRecommendationSecond.text!.count == 3 {
                secondRecommendationHighlight.frame.size.width = 124
            } else if genreRecommendationSecond.text!.count == 4 {
                secondRecommendationHighlight.frame.size.width = 144
            } else if genreRecommendationSecond.text!.count == 5 {
                secondRecommendationHighlight.frame.size.width = 154
            } else if genreRecommendationSecond.text!.count == 7 {
                secondRecommendationHighlight.frame.size.width = 198
            }
                
            randomRoomModels = roomDataManager.roomData.filter { RoomModel in
                RoomModel.genre == genreRecommendation.text!.components(separatedBy: " ")[0] &&
                RoomModel.location == currentLocationLabel.text!.components(separatedBy: " ")[0]
            }
            randomRoomModelsSecond = roomDataManager.roomData.filter { RoomModel in
                RoomModel.genre == genreRecommendationSecond.text!.components(separatedBy: " ")[0] &&
                RoomModel.location == currentLocationLabel.text!.components(separatedBy: " ")[0]
            }
        }
        
        genreRecommendation.text = genreRecommendation.text! + introLabel
        genreRecommendationSecond.text = genreRecommendationSecond.text! + introLabel
    
    }
    
    private func configureDelegateSetting() {
        // LocationCollectionView Setting
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.register(
            UINib(nibName: Constants.roomCollectionViewCell, bundle: nil),
            forCellWithReuseIdentifier: Constants.roomCollectionViewCell
        )
        locationCollectionView.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        
        // RecommendationCollectionView Setting
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
        recommendationCollectionView.register(
            UINib(nibName: Constants.roomCollectionViewCell, bundle: nil),
            forCellWithReuseIdentifier: Constants.roomCollectionViewCell
        )
        recommendationCollectionView.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        
        // RecommendationCollectionViewSecond Setting
        recommendationCollectionViewSecond.delegate = self
        recommendationCollectionViewSecond.dataSource = self
        recommendationCollectionViewSecond.register(
            UINib(nibName: Constants.roomCollectionViewCell, bundle: nil),
            forCellWithReuseIdentifier: Constants.roomCollectionViewCell
        )
        recommendationCollectionViewSecond.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
    }
    
    private func configruePulldownButton() {
        let button1 = UIAction(title: "경주시") { _ in self.changeCurrentLocation(location: "경주시") }
        let button2 = UIAction(title: "대구광역시") { _ in self.changeCurrentLocation(location: "대구광역시") }
        let button3 = UIAction(title: "포항시") { _ in self.changeCurrentLocation(location: "포항시") }
        let buttonMenu = UIMenu(children: [button1, button2, button3])
        currentLocationButton.showsMenuAsPrimaryAction = true
        currentLocationButton.menu = buttonMenu
    }
    
    private func changeCurrentLocation(location: String) {
        currentLocationButton.setTitle(location, for: .normal)
        currentLocationLabel.text = location + " 근처"
        
        if location.count == 3 {
            currentLocationHighlight.frame.size.width = 84
        } else {
            currentLocationHighlight.frame.size.width = 140
        }
        
        arrangeThemeListWithLocationData(location: location)
    }
    
    private func arrangeThemeListWithLocationData(location: String) {
        locationRoomModels = roomDataManager.roomData.filter { RoomModel in
            RoomModel.location == location
        }
        randomRoomModels = roomDataManager.roomData.filter { RoomModel in
            RoomModel.genre == genreRecommendation.text!.components(separatedBy: "테")[0] &&
            RoomModel.location == currentLocationLabel.text!.components(separatedBy: " ")[0]
        }
        randomRoomModelsSecond = roomDataManager.roomData.filter { RoomModel in
            RoomModel.genre == genreRecommendationSecond.text!.components(separatedBy: "테")[0] &&
            RoomModel.location == currentLocationLabel.text!.components(separatedBy: " ")[0]
        }
        
        locationCollectionView.reloadData()
        recommendationCollectionView.reloadData()
        recommendationCollectionViewSecond.reloadData()
    }
    
    @IBAction func locationAllViewButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.locationAllViewButton.layer.opacity = 0.5
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.locationAllViewButton.layer.opacity = 1
            }
        })
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "AllThemeRef") as? AllThemeViewController else { return }
        guard let currentTitle = currentLocationButton.currentTitle else { return }
        
        viewController.themeByLocation = currentTitle
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func firstGenreAllViewButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.firstGenreAllViewButton.layer.opacity = 0.5
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.firstGenreAllViewButton.layer.opacity = 1
            }
        })
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "AllThemeRef") as? AllThemeViewController else { return }
        guard let genreRecommendation = genreRecommendation.text else { return }
        
        viewController.themeByRecommendation = genreRecommendation
        viewController.currentLocation = currentLocationButton.currentTitle!
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func secondGenreAllViewButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.secondGenreAllViewButton.layer.opacity = 0.5
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.secondGenreAllViewButton.layer.opacity = 1
            }
        })
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "AllThemeRef") as? AllThemeViewController else { return }
        guard let genreRecommendation = genreRecommendationSecond.text else { return }
        
        viewController.themeByRecommendation = genreRecommendation
        viewController.currentLocation = currentLocationButton.currentTitle!
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}// HomeViewController

// MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Quantity of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.locationCollectionView {
            return locationRoomModels.count
        } else if collectionView == self.recommendationCollectionView {
            return randomRoomModels.count
        } else {
            return randomRoomModelsSecond.count
        }
    }
    
    // Size of layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 354)
    }
    
    // Navigation control to the DetailView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RoomCollectionViewCell else { return }
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DetailViewControllerRef") as? DetailViewController else { return }
        
        viewController.roomIndex = cell.index - 1
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}// HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.roomCollectionViewCell, for: indexPath) as! RoomCollectionViewCell
        var roomInfo: RoomModel? = nil
        
        // CollectionView setting
        if collectionView == self.locationCollectionView {
            roomInfo = locationRoomModels[indexPath.row]
        } else if collectionView == self.recommendationCollectionView {
            roomInfo = randomRoomModels[indexPath.row]
        } else {
            roomInfo = randomRoomModelsSecond[indexPath.row]
        }
        
        let url = URL(string: roomInfo!.image)
        
        cell.roomName?.text = roomInfo!.title
        cell.storeName?.text = roomInfo!.storeName
        cell.roomImage?.contentMode = .scaleToFill
        cell.index = roomInfo!.id
        
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
    
}// HomeViewController: UICollectionViewDataSource

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude: Double = locationValue.latitude
        let longitude: Double = locationValue.longitude

        locationManager.stopUpdatingLocation()

        /*
         대구 from Google: 35.8714° N, 128.6014° E
         대구 from CL: 35.8603515625 / 128.51286659713895
         ------
         포항 36.0190° N, 129.3435° E
         ------
         경주 35.8562° N, 129.2247° E
         */
        switch (floor(latitude), floor(longitude)) {
        case (35, 128):
            // 대구광역시
            changeCurrentLocation(location: "대구광역시")
            return
        case (36, 129):
            // 포항시
            changeCurrentLocation(location: "포항시")
            return
        case (35, 129):
            // 경주시
            changeCurrentLocation(location: "경주시")
            return
        default:
            // 포항 if proper location info wouldn't be provided
            changeCurrentLocation(location: "포항시")
            return
        }
    }
}
