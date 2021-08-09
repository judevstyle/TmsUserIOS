//
//  UIFont+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 3/27/21.
//

import Foundation
import UIKit

extension UIFont {
    
    static func PrimaryBold(size: CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Bold", size: size)!
    }

    static func PrimaryMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Medium", size: size)!
    }

    static func PrimaryText(size: CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Text", size: size)!
    }

    static func PrimaryLight(size: CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Light", size: size)!
    }
    
    static func PrimarySemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-SemiBold", size: size)!
    }
    
    static func PrimaryThin(size: CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Thin", size: size)!
    }
}
