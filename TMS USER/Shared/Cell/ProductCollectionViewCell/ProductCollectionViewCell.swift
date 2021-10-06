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
    
    @IBOutlet var promotionView: UIView!
    @IBOutlet var promotionText: UILabel!
    
    var itemsProduct: ProductItems? {
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
        
        if let discount = itemsProduct?.productDiscount {
            let attributeString =  NSMutableAttributedString(string: "\(itemsProduct?.productPrice ?? 0)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, attributeString.length))
            self.priceOld.attributedText = attributeString
            self.priceNew.text = "\(discount.newPrice ?? 0)"
            priceOld.isHidden = false
        } else {
            priceOld.isHidden = true
            priceNew.text = "\(itemsProduct?.productPrice ?? 0)"
        }
        
        priceNew.sizeToFit()
        priceOld.sizeToFit()
        setImage(url: itemsProduct?.productImg)
        
        if itemsProduct?.isPromotion == true {
            promotionView.isHidden = false
            promotionText.isHidden = false
            promotionView.setRounded(rounded: 8)
        } else {
            promotionView.isHidden = true
            promotionText.isHidden = true
        }
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.TMSImagePath.urlString)\(url ?? "")") else { return }
        imageThumbnail.kf.setImageDefault(with: urlImage)
    }
}
