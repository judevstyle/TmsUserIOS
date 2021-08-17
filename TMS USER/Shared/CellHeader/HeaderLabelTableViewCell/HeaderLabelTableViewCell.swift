//
//  HeaderLabelTableViewCell.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/17/21.
//

import UIKit
import SnapKit

class HeaderLabelTableViewCell: UITableViewHeaderFooterView {
    
    private var leftLabel : PaddingLabel = {
        let label = PaddingLabel(withInsets: 0, 0, 0, 0)
        label.textColor = UIColor.black
        return label
    }()
    
    static let identifier = "HeaderLabelTableViewCell"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.leftLabel)
        
        self.leftLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }

        leftLabel.textAlignment = .left
        leftLabel.font = UIFont.PrimaryMedium(size: 13)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(title:String) {
        self.leftLabel.text = title
        self.contentView.backgroundColor = .white
        self.leftLabel.sizeToFit()
    }
    
}
