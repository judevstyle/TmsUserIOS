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
        self.font = .PrimaryMedium(size: 16)
        self.textColor = .Primary
    }
}

class ValueManageProfile: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryMedium(size: 18)
        self.textColor = .darkGray
    }
}

class TextEmptyData: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryMedium(size: 18)
        self.textColor = .darkGray
        self.text = "ไม่พบข้อมูล"
    }
}
