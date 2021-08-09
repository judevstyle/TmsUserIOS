//
//  ProductCollectionViewCell.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/15/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    @IBOutlet weak var priceOld: UILabel!
    @IBOutlet weak var priceNew: UILabel!
    
    static let identifier = "ProductCollectionViewCell"
    
    
    @IBOutlet var viewBoxPrice: UIView!
    
    
    var itemsProduct: Product? {
        didSet {
            setupValueProduct()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    func setupUI(){
        self.setRounded(rounded: 8)
        bgView.setRounded(rounded: 8)
        bgView.setShadowBoxView()
//        imageThumbnail.setRounded(rounded: 8)
        imageThumbnail.roundedTop(radius: 8)
    }
    
    func setupValueProduct() {
        titleText.text = itemsProduct?.productName ?? ""
        descText.text = itemsProduct?.productDesc ?? ""
        self.priceOld.isHidden = true
        self.priceNew.text = "\(itemsProduct?.productPrice ?? 0)"
        setImage(url: itemsProduct?.productImg)
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.TMSImagePath.urlString)\(url ?? "")") else { return }
        imageThumbnail.kf.setImageDefault(with: urlImage)
    }
}
