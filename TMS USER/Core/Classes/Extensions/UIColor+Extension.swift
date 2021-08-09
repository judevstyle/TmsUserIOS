//
//  UIColor+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 3/29/21.
//

import Foundation
import UIKit

extension UIColor {
    
    static func whiteAlpha(alpha: CGFloat) -> UIColor {
        return UIColor(white: 1, alpha: alpha)
    }

    static func blackAlpha(alpha: CGFloat) -> UIColor {
        return UIColor(white: 0, alpha: alpha)
    }
    
    static func Alpha(alpha: CGFloat) -> UIColor {
        return UIColor(white: 0, alpha: alpha)
    }

    static let Primary = UIColor(named: "Primary")!
    static let PrimaryBG = UIColor(named: "PrimaryBG")!
    static let PrimaryGray = UIColor(named: "PrimaryGray")!
    static let PrimaryUnselectTabbar = UIColor(named: "PrimaryUnselect")!
    static let PrimaryBGTabbar = UIColor(named: "PrimaryBGTabbar")!
    static let PrimaryAlpha = UIColor(named: "PrimaryAlpha")!
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static var jetBlack = UIColor.rgb(red: 33, green: 45, blue: 79)
    static var gold = UIColor.rgb(red: 255, green: 182, blue: 0)
    static var kelly = UIColor.rgb(red: 0, green: 206, blue: 62)
    static var mediumBlue = UIColor.rgb(red: 0, green: 122, blue: 255)
    static var rosePink = UIColor.rgb(red: 255, green: 193, blue: 224)
    static var navy = UIColor.rgb(red: 66, green: 66, blue: 136)
    static var emerald = UIColor.rgb(red: 0, green: 222, blue: 182)
    static var lolipop = UIColor.rgb(red: 143, green: 20, blue: 108)
    static var ruby = UIColor.rgb(red: 235, green: 42, blue: 117)
    
}
