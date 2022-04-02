//
//  UILabelCustomClass.swift
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

class TextSectionInput: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryMedium(size: 16)
        self.textColor = .darkGray
    }
}

class TextTitleCellBlack: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryMedium(size: 16)
        self.textColor = .black
    }
}

class TextDescCellDarkGray: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryMedium(size: 14)
        self.textColor = .darkGray
    }
}


// MARK: - CustomerPoint

class TextHeadPoint: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimarySemiBold(size: 20)
        self.textColor = .darkGray
        self.text = "การสะสมเหรียญของคุณ"
    }
}

class TextValuePoint: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = .PrimaryBold(size: 60)
        self.textColor = .Primary
        self.text = "0"
    }
}
