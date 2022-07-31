//
//  RoomSelectionTableViewCell.swift
//  RoomEscape
//
//  Created by Wonhyuk Choi on 2022/07/27.
//

import UIKit

class RoomSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomName: UITextView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var difficulties: UIStackView!
    @IBOutlet weak var selectionCover: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionCover.layer.borderWidth = 1
        selectionCover.layer.cornerRadius = 10
        roomImage.layer.cornerRadius = 10
        roomName.textContainerInset = .zero
        roomName.textContainer.maximumNumberOfLines = 2
        roomName.textContainer.lineBreakMode = .byTruncatingTail
        selectionCover.layer.borderColor = UIColor.background2?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            selectionCover.backgroundColor = UIColor.background2
            selectionCover.layer.borderColor = UIColor.mainPurple?.cgColor
        } else {
            selectionCover.backgroundColor = UIColor.background
            selectionCover.layer.borderColor = UIColor.background2?.cgColor
        }
    }
    
}
