//
//  ProductCategoryCollectionViewCell.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/18/21.
//

import UIKit

class ProductCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCategoryCollectionViewCell"

    @IBOutlet var bgView: UIView!
    @IBOutlet var titleText: UILabel!
    
    
    var items: ProductType? {
        didSet {
            setupValue()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                bgView.backgroundColor = UIColor.Primary
                titleText.textColor = .white
            } else {
                bgView.backgroundColor = UIColor.white
                titleText.textColor = .darkGray
            }
        }
    }
    
    func setupUI() {
        bgView.setRounded(rounded: 8)
        bgView.setShadowBoxView()
//        titleText.tintColor = .white
    }
    
    func setupValue() {
        titleText.text = items?.productTypeName ?? ""
    }
    
}


