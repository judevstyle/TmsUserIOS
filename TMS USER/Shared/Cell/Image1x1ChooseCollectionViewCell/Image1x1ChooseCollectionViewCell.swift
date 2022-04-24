//
//  Image1x1ChooseCollectionViewCell.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/15/21.
//

import UIKit

class Image1x1ChooseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    static let identifier = "Image1x1ChooseCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        bgView.setRounded(rounded: 8)
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 0.5
        
    }

}
