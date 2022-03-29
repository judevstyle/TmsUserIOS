//
//  HeadTitleTFLabel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 29/3/2565 BE.
//

import Foundation
import UIKit

class HeadTitleTFLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryText(size: 16)
        self.textColor = .darkGray
    }
}
