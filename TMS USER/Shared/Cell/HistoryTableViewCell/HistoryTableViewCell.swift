//
//  HistoryTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import UIKit

protocol HistoryTableViewCellDelegate {
    func didCreateOrder(index: Int?)
}

class HistoryTableViewCell: UITableViewCell {
    
    static let identifier = "HistoryTableViewCell"
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var orderNoText: UILabel!
    
    @IBOutlet var countOrder: UILabel!
    
    @IBOutlet var dateText: UILabel!
    
    @IBOutlet var priceOrder: UILabel!
    
    @IBOutlet var btnCreateOrder: UIButton!
    
    public var delegate: HistoryTableViewCellDelegate!
    
    public var index: Int?
    
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
        btnCreateOrder.setRounded(rounded: 5)
        btnCreateOrder.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                     locations: [0.5, 1.0],
                                     direction: .leftToRight,
                                     cornerRadius: 5)
        
        btnCreateOrder.addTarget(self, action: #selector(didCreateOrder), for: .touchUpInside)
    }
    
    @objc func didCreateOrder() {
        self.delegate.didCreateOrder(index: self.index)
    }
    
    func setupValue() {
        orderNoText.text = "Order ID \(item?.orderNo ?? "")"
        countOrder.text = "สั่งซื้อ \(item?.creditStatus ?? 0) รายการ"
        priceOrder.text = "฿ \(item?.balance ?? 0)"
        
        if let dateStr = item?.createDate {
            let formatter = Foundation.DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 7)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //2017-04-01T18:05:00.000
            let date  = formatter.date(from: dateStr)

            formatter.dateFormat = "dd"
            let dayStr = formatter.string(from: date!)
            
            formatter.dateFormat = "MM"
            let mountStr = formatter.string(from: date!)
            
            formatter.dateFormat = "yyyy"
            let yearStr = formatter.string(from: date!)
            
            if let nameMount = mountStr.getMonthsName() {
                dateText.text = "\(dayStr) \(nameMount) \(yearStr)"
            }
        }

        
        orderNoText.sizeToFit()
        countOrder.sizeToFit()
        dateText.sizeToFit()
        priceOrder.sizeToFit()
    }
    
}
