//
//  ProductDetailViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 9/30/21.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleName: UILabel!
    @IBOutlet var descText: UILabel!
    @IBOutlet var sizeText: UILabel!
    @IBOutlet var pointText: UILabel!
    
    @IBOutlet var duscountPrice: UILabel!
    @IBOutlet var priceBalance: UILabel!
    
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var inputQty: UITextField!
    
    //Badge
    @IBOutlet var promotionView: UIView!
    @IBOutlet var promotionText: UILabel!
    
    //Promotion
    @IBOutlet var listPromotionText: UILabel!
    @IBOutlet var promotionTextView: UIView!
    
    //Keyboard
    @IBOutlet var keyBoardHeight: NSLayoutConstraint!
    
    @IBOutlet var scrollView: UIScrollView!
    
    lazy var viewModel: ProductDetailProtocol = {
        let vm = ProductDetailViewModel(productDetailViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewModel.input.getProductDetail()
        registerKeyboardObserver()
    }
    
    func configure(_ interface: ProductDetailProtocol) {
        self.viewModel = interface
    }
    
    deinit {
       removeObserver()
    }
    
}

// MARK: - Binding
extension ProductDetailViewController {
    
    func bindToViewModel() {
        viewModel.output.didUpdateQty = didUpdateQty()
        viewModel.output.didGetProductDetailSuccess = didGetProductDetailSuccess()
    }
    
    func didUpdateQty() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.inputQty.text = weakSelf.viewModel.output.getQty()
        }
    }
    
    func didGetProductDetailSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupValue()
        }
    }
}

extension ProductDetailViewController {
    func setupUI() {
        btnAdd.setRounded(rounded: btnAdd.frame.width/2)
        btnDelete.setRounded(rounded: btnDelete.frame.width/2)
        
        btnSave.setRounded(rounded: 8)
        
        inputQty.keyboardType = .numberPad
        
        btnDelete.addTarget(self, action: #selector(handleDeleteQty), for: .touchUpInside)
        btnAdd.addTarget(self, action: #selector(handleAddQty), for: .touchUpInside)
        btnSave.addTarget(self, action: #selector(handleSaveProduct), for: .touchUpInside)
    }
    
    func setupValue() {
        
        guard let item = viewModel.output.getProducItems() else { return }
        
        titleName.text = item.productName
        descText.text = item.productDesc
        sizeText.text = "ขนาด/ความจุ : \(item.productDimension ?? "")"
        pointText.text = "ได้เหรียญสะสมทุการซื้อ : \(item.productPoint ?? 0) ชิ้นต่อ \(item.productCountPerPoint ?? 0) เหรียญ"
        
        
        priceBalance.text = "\(item.productPrice ?? 0)"
        
        if let discount = item.productDiscount {
            duscountPrice.isHidden = false
            let attributeString =  NSMutableAttributedString(string: "\(item.productPrice ?? 0)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, attributeString.length))
            
            duscountPrice.attributedText = attributeString
            priceBalance.text = "\(discount.newPrice ?? 0)"
            duscountPrice.sizeToFit()
        } else {
            duscountPrice.isHidden = true
        }
        
        let objs = OrderCartManager.sharedInstance.getProductCart()
        
        if let itemObj = objs?.first(where: { $0?.productId == item.productId }) {
            inputQty.text = "\(itemObj?.productCartQty ?? 0)"
        } else {
            inputQty.text = "0"
        }
        
        priceBalance.sizeToFit()
        
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(item.productImg ?? "")") else { return }
        posterImageView.kf.setImageDefault(with: urlImage)
        
        //Badge
        if item.isPromotion == true {
            promotionView.isHidden = false
            promotionText.isHidden = false
            promotionView.setRounded(rounded: 8)
            
            promotionTextView.isHidden = false
            var listText: String = ""
            item.promotion?.enumerated().forEach({ (index, promotion) in
                if index == 0 {
                    listText += "เมื่อซื้อขั้นต่ำ \(promotion.qty ?? 0) ขึ้นไป ราคาอยู่ที่ \(promotion.itemPrice ?? 0) บาท/ชิ้น"
                } else {
                    listText += "\nเมื่อซื้อขั้นต่ำ \(promotion.qty ?? 0) ขึ้นไป ราคาอยู่ที่ \(promotion.itemPrice ?? 0) บาท/ชิ้น"
                }
            })
            listPromotionText.text = listText
        } else {
            promotionView.isHidden = true
            promotionText.isHidden = true
            
            promotionTextView.isHidden = true
        }
        
        
        
    }
}

extension ProductDetailViewController {
    @objc func handleDeleteQty() {
        guard let textQty = self.inputQty.text, !textQty.isEmpty else { return }
        viewModel.input.didDeleteQty(qty: textQty)
    }
    
    @objc func handleAddQty() {
        guard let textQty = self.inputQty.text, !textQty.isEmpty else { return }
        viewModel.input.didAddQty(qty: textQty)
    }
    
    @objc func handleSaveProduct() {
        guard let textQty = self.inputQty.text, !textQty.isEmpty else { return }
        viewModel.input.didConfrimProduct(qty: textQty)
    }
}

extension ProductDetailViewController : KeyboardListener {
    func keyboardDidUpdate(keyboardHeight: CGFloat) {
        keyBoardHeight.constant = keyboardHeight
        if keyBoardHeight.constant > 0 {
            DispatchQueue.main.async {
                self.scrollView.scrollToBottom(animated: false)
            }
        } else {
            DispatchQueue.main.async {
                self.scrollView.scrollToTop(animated: false)
            }
        }
    }
}
