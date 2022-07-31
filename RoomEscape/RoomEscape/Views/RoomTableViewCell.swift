//
//  RoomCell.swift
//  RoomEscape
//
//  Created by Wonhyuk Choi on 2022/07/19.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomName: UITextView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var difficulties: UIStackView!
    @IBOutlet weak var selectionCover: UIView!
    @IBOutlet weak var genre: UILabel!
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roomImage.layer.cornerRadius = 10
        roomName.textContainerInset = .zero
        roomName.textContainer.maximumNumberOfLines = 2
        roomName.textContainer.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
