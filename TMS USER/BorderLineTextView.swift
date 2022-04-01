//
//  BorderLineTextView.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 29/3/2565 BE.
//

import Foundation
import UIKit

class BorderLineTextView: UITextView {
    private let defaultBorderineColor = UIColor.Primary

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = defaultBorderineColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
        self.font = .PrimaryMedium(size: 16)
    }

    public func setBorderLineColor(color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
}
