//
//  ProfileTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var menuText: UILabel!
    
    var title: String? {
        didSet {
            menuText.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
