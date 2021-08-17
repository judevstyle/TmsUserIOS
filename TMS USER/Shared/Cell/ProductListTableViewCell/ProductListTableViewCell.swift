//
//  ProductListTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    static let identifier = "ProductListTableViewCell"
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var imagePoster: UIImageView!
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var descText: UILabel!
    @IBOutlet var priceText: UILabel!
    @IBOutlet var countText: UILabel!
    
    @IBOutlet var priceAllText: UILabel!
    
    var orderD: OrderD? {
        didSet {
            setupValueOrderD()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        bgView.setRounded(rounded: 8)
        bgView.setShadowBoxView()
        imagePoster.setRounded(rounded: 8)
        imagePoster.contentMode = .scaleAspectFill
    }
    
    func setupValueOrderD() {
        titleText.text = orderD?.product?.productName ?? ""
        descText.text = orderD?.product?.productDesc ?? ""
        priceText.text = "฿\(orderD?.price ?? 0)"
        
        countText.text = "x\(orderD?.qty ?? 1)"
        
        priceAllText.text = "รวม ฿\((orderD?.qty ?? 1) * (orderD?.price ?? 0))"
        
        setImage(url: orderD?.product?.productImg)
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.TMSImagePath.urlString)\(url ?? "")") else { return }
        imagePoster.kf.setImageDefault(with: urlImage)
    }
}
