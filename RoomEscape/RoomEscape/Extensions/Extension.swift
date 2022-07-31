//
//  Extension.swift
//  RoomEscape
//
//  Created by MINJI on 2022/07/18.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    // 피그마에 등록된 색상 보시고, 사용하시면 됩니다!
    //self.myButton.backgroundColor = UIColor.titleWhite 혹은 self.myButton.backgroundColor = .titleWhite 이런식으로 사용
    

    // Title Color
    static let titleWhite = UIColor(named: "text1")
    static let titleLightgray = UIColor(named: "text2")
    static let titleGray = UIColor(named: "text3")
    static let titleDarkGray = UIColor(named: "text4")
    static let titleBlack = UIColor(named: "text5")

    // Main Color
    static let mainPurple = UIColor(named: "Main")
    
    //etc
    static let background = UIColor(named: "Background")
    static let background2 = UIColor(named: "Background2")
    static let star = UIColor(named: "star")
    
}

// https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension View {
    func asUiImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let window = UIWindow(frame: view!.bounds)
        window.addSubview(controller.view)
        window.makeKeyAndVisible()
        
        let renderer = UIGraphicsImageRenderer(bounds: view!.bounds, format: format)
        return renderer.image { rendererContext in
            view?.layer.render(in: rendererContext.cgContext)
        }
    }
}
