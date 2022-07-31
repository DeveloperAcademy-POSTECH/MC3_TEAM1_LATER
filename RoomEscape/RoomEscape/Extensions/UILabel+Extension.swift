//
//  UILabel+Extension.swift
//  RoomEscape
//
//  Created by KiWoong Hong on 2022/07/20.
//

import Foundation
import UIKit

extension UILabel {
    // MARK: - ThemmaCompareViewController 에서 사용하는 UILabel Extension
    func setBetter() {
        self.font = .boldSystemFont(ofSize: 19)
        self.textColor = .mainPurple
    }
    
    func setWorse() {
        self.font = .boldSystemFont(ofSize: 19)
        self.textColor = .titleBlack
    }
}
