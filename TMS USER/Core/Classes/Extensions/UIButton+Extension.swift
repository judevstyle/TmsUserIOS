//
//  UIButton+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 3/26/21.
//

import Foundation
import UIKit

extension UIButton {
    
    enum Direction: Int {
          case topToBottom = 0
          case bottomToTop
          case leftToRight
          case rightToLeft
      }
    
    func addGradientButton(colors: [Any]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .leftToRight, cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = cornerRadius
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }

        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
}
