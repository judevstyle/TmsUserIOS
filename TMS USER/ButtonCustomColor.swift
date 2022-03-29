//
//  ButtonCustomColor.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 29/3/2565 BE.
//

import Foundation
import UIKit

class ButtonCustomColor: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .systemGreen
        self.titleLabel?.font = .PrimaryText(size: 15)
        self.tintColor = .white
        self.layer.cornerRadius = 5
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}
