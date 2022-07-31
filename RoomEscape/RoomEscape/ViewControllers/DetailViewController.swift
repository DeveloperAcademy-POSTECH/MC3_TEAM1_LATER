//
//  DetailViewController.swift
//  RoomEscape
//
//  Created by ICHAN NAM on 2022/07/20.
//

import Foundation

import UIKit

class DetailViewController: UIViewController {
    
    var roomIndex: Int = 0
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var activity: UILabel!
    @IBOutlet weak var horror: UILabel!
    @IBOutlet weak var roomDescription: UILabel!
    @IBOutlet weak var recommendation: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    
    @IBOutlet weak var pickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let roomModel: RoomModel = JSONDataManager.shared.roomData[roomIndex]
        
        loadPosterFrom(urlAddress: roomModel.image)
        
        recommendation.text = roomModel.recommendation + "에게 추천"
        
        genre.text = roomModel.genre + " 테마"
        roomTitle.text = roomModel.title
        storeName.text = roomModel.storeName
        
        difficulty.text = String(roomModel.difficulty) + ".0"
        activity.text = String(roomModel.activity) + ".0"
        horror.text = String(roomModel.horror) + ".0"
        
        roomDescription.text = roomModel.description
        
        self.changeRecommendationSuffix()
        
        pickButton.addTarget(self, action: #selector(pickButtonTapped), for: .touchUpInside)
    }
    
    func changeRecommendationSuffix() {
        guard let text = self.recommendation.text else { return }
        
        let suffix = "에게 추천"
        
        let attributeString = NSMutableAttributedString(string: text)
        
        attributeString.addAttribute(.foregroundColor, value: UIColor.titleDarkGray as Any, range: (text as NSString).range(of: suffix))
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0, weight: .regular), range: (text as NSString).range(of: suffix))
        
        self.recommendation.attributedText = attributeString
    }
    
    func loadPosterFrom(urlAddress: String) {
        guard let url = URL(string: urlAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.poster.image = loadedImage
                    self?.poster.clipsToBounds = true
                    self?.poster.contentMode = .scaleToFill
                }
            }
        }
    }
    
    @objc func pickButtonTapped() {
        let detailPickSheetVC = DetailPickSheetViewController(contentViewController: UIStoryboard(name: "PickSheet", bundle: nil)
            .instantiateViewController(withIdentifier: "PickSheetViewController") as? PickSheetViewController ?? UIViewController(), roomIndex: self.roomIndex)
        detailPickSheetVC.modalPresentationStyle = .overFullScreen
        self.present(detailPickSheetVC, animated: false, completion: nil)
    }
}
