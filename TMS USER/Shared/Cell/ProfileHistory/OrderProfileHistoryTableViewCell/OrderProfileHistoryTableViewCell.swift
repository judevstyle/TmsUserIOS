//
//  OrderProfileHistoryTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 11/4/2565 BE.
//

import UIKit

protocol OrderProfileHistoryTableViewCellDelegate {
    func didCancelOrder(orderId: Int)
    func didReOrder(orderId: Int)
    func didReviewOrder(orderId: Int)
}

class OrderProfileHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "OrderProfileHistoryTableViewCell"
    
    @IBOutlet var bgView: UIView!
    
    
    @IBOutlet var bgWaitApprove: UIView!
    @IBOutlet var bgSuccess: UIView!
    @IBOutlet var bgRejectAndCancel: UIView!
    
    @IBOutlet var orderIdText: UILabel!
    @IBOutlet var priceText: UILabel!
    @IBOutlet var countOrder: UILabel!
    
    //BoxWaitApprove
    @IBOutlet var dateWaitApprove: UILabel!
    @IBOutlet var btnWaitApprove: ButtonCancelOrder!
    
    //BoxSuccess
    @IBOutlet var dateSuccess: UILabel!
    @IBOutlet var btnReviewOrder: ButtonReviewOrder!
    
    //BoxRejectAndCancel
    @IBOutlet var dateRejectAndCancel: UILabel!
    @IBOutlet var statusRejectAndCancel: UILabel!
    @IBOutlet var btnReOrder: ButtonReOrder!
    
    public var delegate: OrderProfileHistoryTableViewCellDelegate?
    
    public var index: Int?
    
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
    }
    
    func setupValue(item: OrderItems?, type: IndexProfileHistoryType?) {
        self.orderItem = item
        orderIdText.text = "Order ID \(item?.orderNo ?? "")"
        countOrder.text = "สั่งซื้อ \(item?.totalItem ?? 0) รายการ"
        priceText.text = "฿ \(item?.balance ?? 0)"
        
        self.orderIdText.sizeToFit()
        self.countOrder.sizeToFit()
        self.priceText.sizeToFit()
        
        bgWaitApprove.isHidden = true
        bgSuccess.isHidden = true
        bgRejectAndCancel.isHidden = true
        
        switch type {
        case .waitApprove:
            bgWaitApprove.isHidden = false
            btnWaitApprove.setRounded(rounded: 5)
            if let createDate = item?.createDate  {
                let dateTxt = createDate.convertToDate()?.getFormattedDate(format: "dd/MM/yyyy HH:mm") ?? ""
                self.dateWaitApprove.text = "สั่งซื้อเมื่อวันที่ \(dateTxt)"
            } else {
                self.dateWaitApprove.text = ""
            }
            self.dateWaitApprove.sizeToFit()
            break
        case .success:
            bgSuccess.isHidden = false
            
            if item?.haveFeedback == true {
                btnReOrder.isHidden = false
                btnReviewOrder.isHidden = true
                btnReOrder.setRounded(rounded: 5)
            } else {
                btnReOrder.isHidden = true
                btnReviewOrder.isHidden = false
                btnReviewOrder.setRounded(rounded: 5)
            }
            
            if let createDate = item?.sendDateStamp  {
                let dateTxt = createDate.convertToDate()?.getFormattedDate(format: "dd/MM/yyyy HH:mm") ?? ""
                self.dateSuccess.text = "จัดส่งเมื่อวันที่ \(dateTxt)"
            } else {
                self.dateSuccess.text = ""
            }
            self.dateSuccess.sizeToFit()
            break
        case .reject:
            bgRejectAndCancel.isHidden = false
            statusRejectAndCancel.text = item?.statusRemark ?? ""
            statusRejectAndCancel.isHidden = item?.statusRemark?.isEmpty == true ? true : false
            
            if let updateDate = item?.updateDate  {
                let dateTxt = updateDate.convertToDate()?.getFormattedDate(format: "dd/MM/yyyy HH:mm") ?? ""
                self.dateRejectAndCancel.text = "วันที่ \(dateTxt)"
            } else {
                self.dateRejectAndCancel.text = ""
            }
            self.dateRejectAndCancel.sizeToFit()
            break
        case .cancel:
            bgRejectAndCancel.isHidden = false
            statusRejectAndCancel.text = item?.statusRemark ?? ""
            statusRejectAndCancel.isHidden = item?.statusRemark?.isEmpty == true ? true : false
            
            if let updateDate = item?.updateDate  {
                let dateTxt = updateDate.convertToDate()?.getFormattedDate(format: "dd/MM/yyyy HH:mm") ?? ""
                self.dateRejectAndCancel.text = "วันที่ \(dateTxt)"
            } else {
                self.dateRejectAndCancel.text = ""
            }
            self.dateRejectAndCancel.sizeToFit()
            break
        default:
            break
        }
    }
    
    @IBAction func handleCancelOrder(_ sender: Any) {
        if let orderId = orderItem?.orderId {
            self.delegate?.didCancelOrder(orderId: orderId)
        }
    }
    
    @IBAction func handleReviewOrder(_ sender: Any) {
        if let orderId = orderItem?.orderId {
            self.delegate?.didReviewOrder(orderId: orderId)
        }
    }
    
    @IBAction func handleReOrder(_ sender: Any) {
        if let orderId = orderItem?.orderId {
            self.delegate?.didReOrder(orderId: orderId)
        }
    }
}
