//
//  ProductCartTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import UIKit

protocol ProductCartTableViewCellDelegate {
    func didUpdateQty()
    func didRemoveProduct(item: ProductItems?)
}

class ProductCartTableViewCell: UITableViewCell {

    static let identifier = "ProductCartTableViewCell"
    @IBOutlet weak var orderCartView: UIView!
    
    @IBOutlet weak var imageThubnail: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    @IBOutlet var priceOld: UILabel!
    @IBOutlet var priceNew: UILabel!
    
    @IBOutlet weak var priceText: UILabel!
    
    @IBOutlet weak var qytText: UILabel!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var removeCart: UIButton!
    
    public var delegate: ProductCartTableViewCellDelegate!
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        
        orderCartView.setRounded(rounded: 8)
        imageThubnail.setRounded(rounded: 8)
        
        titleText.font = UIFont.PrimaryText(size: 12)
        descText.font = UIFont.PrimaryText(size: 10)
        
        priceText.font = UIFont.PrimaryText(size: 14)
        
        deleteButton.setRounded(rounded: deleteButton.frame.width/2)
        addButton.setRounded(rounded: addButton.frame.width/2)
    }
    @IBAction func DeleteQtyAction(_ sender: Any) {
        
        let number:Int? = Int(qytText.text ?? "")
        if var numberNew = number, numberNew > 1 {
            numberNew -= 1
            qytText.text = "\(numberNew)"
            updateQty()
        }
    }
    
    @IBAction func AddQtyAction(_ sender: Any) {
        
        let number:Int? = Int(qytText.text ?? "")
        if var numberNew = number {
            numberNew += 1
            qytText.text = "\(numberNew)"
            updateQty()
        }
    }
    
    func updateQty() {
        let qty:Int? = Int(qytText.text ?? "")
        if let qty = qty, let item = self.itemsProduct {
            OrderCartManager.sharedInstance.updateProductCart(item, qty: qty, completion: {
                self.delegate.didUpdateQty()
            })
        }
        checkDisableDeleteButton()
    }
    
    func checkDisableDeleteButton() {
        let qty:Int? = Int(qytText.text ?? "")
        if let qty = qty, qty <= 1 {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
        }
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.delegate.didRemoveProduct(item: self.itemsProduct)
    }
    
    func setupValueProduct() {
        
        titleText.text = itemsProduct?.productName ?? ""
        descText.text = itemsProduct?.productDesc ?? ""
        qytText.text = "\(itemsProduct?.productCartQty ?? 0)"
        
        checkDisableDeleteButton()
        
//        if let discount = itemsProduct?.productDiscount {
//            let attributeString =  NSMutableAttributedString(string: "\(itemsProduct?.productPrice ?? 0)")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
//            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, attributeString.length))
//            self.priceOld.attributedText = attributeString
//            self.priceNew.text = "\(discount.newPrice ?? 0)"
//            priceOld.isHidden = false
//        } else {
//            priceOld.isHidden = true
//            priceNew.text = "\(itemsProduct?.productPrice ?? 0)"
//        }
        
        //new Flow
        
        if let discount = itemsProduct?.productDiscount {
            let attributeString =  NSMutableAttributedString(string: "\(itemsProduct?.productPrice ?? 0)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, attributeString.length))
            self.priceOld.attributedText = attributeString
            priceOld.isHidden = false
        } else {
            priceOld.isHidden = true
        }
        
        if let promotions = itemsProduct?.promotion {
            for item in promotions {
                if itemsProduct?.productCartQty ?? 0 >= item.qty ?? 0 {
                    let attributeString =  NSMutableAttributedString(string: "\(itemsProduct?.productPrice ?? 0)")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
                    attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, attributeString.length))
                    self.priceOld.attributedText = attributeString
                    priceOld.isHidden = false
                    break
                } else {
                    priceOld.isHidden = true
                }
            }
        } else {
            priceOld.isHidden = true
        }
        
        priceNew.text = "\(itemsProduct?.productCartPrice ?? 0)"

        priceNew.sizeToFit()
        priceOld.sizeToFit()
        
        setImage(url: itemsProduct?.productImg)
        
        let qty:Int? = Int(qytText.text ?? "")
        let priceAll:Int? = Int(priceNew.text ?? "")
        if let priceAll = priceAll, let qty = qty {
            priceText.text = "รวม ฿\(priceAll*qty)"
        } else {
            priceText.text = "รวม ฿0"
        }
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(url ?? "")") else { return }
        imageThubnail.kf.setImageDefault(with: urlImage)
    }
}
