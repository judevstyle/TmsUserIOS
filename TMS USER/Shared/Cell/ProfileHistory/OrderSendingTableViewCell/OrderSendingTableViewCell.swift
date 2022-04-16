//
//  OrderSendingTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 16/4/2565 BE.
//

import UIKit

class OrderSendingTableViewCell: UITableViewCell {
    
    static let identifier = "OrderSendingTableViewCell"

    @IBOutlet var bgView: UIView!
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var pricePay: UILabel!
    @IBOutlet var statusText: UILabel!
    
    public var orderItem: OrderItems?
    
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
//        btnCreateOrder.setRounded(rounded: 5)
//        btnCreateOrder.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
//                                     locations: [0.5, 1.0],
//                                     direction: .leftToRight,
//                                     cornerRadius: 5)
//
//        btnCreateOrder.addTarget(self, action: #selector(didCreateOrder), for: .touchUpInside)
    }
    
    func setupValue(item: OrderItems?, type: IndexProfileHistoryType?) {
        titleText.text = "\(item?.orderNo ?? "")"
        pricePay.text = "\(item?.totalPrice ?? 0)"
        statusText.text = "รอการจัดส่ง"
        
        self.titleText.sizeToFit()
        self.pricePay.sizeToFit()
        self.statusText.sizeToFit()
    }
}
