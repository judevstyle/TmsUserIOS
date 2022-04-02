//
//  UIViewCustomClass.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 2/4/2565 BE.
//

import Foundation
import UIKit

// MARK: - CustomerPoint

class ViewBGPoint: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setRounded(rounded: 8)
        self.setShadowBoxView(shadowOpacity: 0.5, shadowRadius: 3)
    }
}
