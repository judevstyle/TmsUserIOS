//
//  LabelCustomClass.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 31/3/2565 BE.
//

import Foundation
import UIKit

class HeadSectionManageProfile: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryText(size: 16)
        self.textColor = .Primary
    }
}

class ValueManageProfile: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryText(size: 18)
        self.textColor = .darkGray
    }
}
