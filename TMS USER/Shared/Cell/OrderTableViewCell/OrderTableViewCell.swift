//
//  OrderTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let identifier = "OrderTableViewCell"
    public var isFirstLayoutSubviews = true

    @IBOutlet var bgView: UIView!
    
    @IBOutlet var imagePoster: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var addressText: UILabel!
    
    @IBOutlet var countProduct: UILabel!
    @IBOutlet var pricePay: UILabel!
    @IBOutlet var statusText: UILabel!
    
    var item: OrderItems? {
        didSet {
            setupValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        bgView.setRounded(rounded: 8)
        bgView.setShadowBoxView()
        imagePoster.setRounded(rounded: 8)
        imagePoster.contentMode = .scaleAspectFill
    }
    
    func setupValue() {

        setImage(url: item?.customerAvatar)
        
        titleText.text = item?.orderNo ?? ""
        addressText.text = item?.customerAddress ?? ""
        countProduct.text = "\(item?.totalItem ?? 0)"
        pricePay.text = "\(item?.balance ?? 0)"
        
        titleText.sizeToFit()
        addressText.sizeToFit()
        
//        statusText.text

    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(url ?? "")") else { return }
        imagePoster.kf.setImageDefault(with: urlImage)
    }
    
}
