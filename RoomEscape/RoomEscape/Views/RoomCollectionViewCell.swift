//
//  RoomCollectionViewCell.swift
//  RoomEscape
//
//  Created by Hyeon-sang Lee on 2022/07/19.
//

import UIKit

class RoomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var selectionCover: UIView!
    var index: Int = 0
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configureSelection()
            } else {
                configureDeselection()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionCover.layer.cornerRadius = 10
        selectionCover.layer.borderColor = UIColor.mainPurple?.cgColor
        
    }
    
    private func configureSelection() {
        selectionCover.layer.borderWidth = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isSelected = false
        }
    }
    
    private func configureDeselection() {
        selectionCover.layer.borderWidth = 0
    }
}
