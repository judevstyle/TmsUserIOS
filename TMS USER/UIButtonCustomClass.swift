//
//  UIButtonCustomClass.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 2/4/2565 BE.
//

import Foundation
import UIKit

// MARK: - CustomerPoint
class ButtonExchangePoint: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setRounded(rounded: self.frame.height/2)
        self.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                     locations: [0.5, 1.0],
                                     direction: .leftToRight,
                                     cornerRadius: self.frame.height/2)
        self.setTitle("แลกของสะสมเดี๋ยวนี้", for: .normal)
        self.titleLabel?.font = .PrimaryMedium(size: 18)
        self.titleLabel?.textColor = .white
    }
}

// MARK: - CollectibleExchange

class ButtonExchangeCollectible: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setRounded(rounded: 8)
        self.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                     locations: [0.5, 1.0],
                                     direction: .leftToRight,
                                     cornerRadius: 8)
        self.setTitle("แลกเดี๋ยวนี้", for: .normal)
        self.titleLabel?.font = .PrimaryMedium(size: 16)
        self.titleLabel?.textColor = .white
    }
}

// MARK: - ModalAcceptViewController
class ButtonInnerColor: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setRounded(rounded: 8)
        self.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                     locations: [0.5, 1.0],
                                     direction: .leftToRight,
                                     cornerRadius: 8)
        self.setTitle("ยืนยัน", for: .normal)
        self.titleLabel?.font = .PrimaryMedium(size: 16)
        self.setTitleColor(.white, for: .normal)
    }
}

class ButtonOutlineColor: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setRounded(rounded: 8)
        self.setBorder(width: 1, color: .Primary)
        self.setTitle("ยกเลิก", for: .normal)
        self.titleLabel?.font = .PrimaryMedium(size: 16)
        self.setTitleColor(.Primary, for: .normal)
    }
}
