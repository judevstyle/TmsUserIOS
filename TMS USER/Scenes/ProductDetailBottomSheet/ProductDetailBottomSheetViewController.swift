//
//  ProductDetailBottomSheetViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import UIKit

class ProductDetailBottomSheetViewController: UIViewController {
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleName: UILabel!
    @IBOutlet var descText: UILabel!
    
    @IBOutlet var duscountPrice: UILabel!
    @IBOutlet var priceBalance: UILabel!
    
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var inputQty: UITextField!
    
    lazy var viewModel: ProductDetailBottomSheetProtocol = {
        let vm = ProductDetailBottomSheetViewModel(productDetailBottomSheetViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func configure(_ interface: ProductDetailBottomSheetProtocol) {
        self.viewModel = interface
    }
    
}

// MARK: - Binding
extension ProductDetailBottomSheetViewController {
    
    func bindToViewModel() {
        viewModel.output.didUpdateQty = didUpdateQty()
    }
    
    func didUpdateQty() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.inputQty.text = weakSelf.viewModel.output.getQty()
        }
    }
}

extension ProductDetailBottomSheetViewController {
    func setupUI() {
        btnAdd.setRounded(rounded: btnAdd.frame.width/2)
        btnDelete.setRounded(rounded: btnDelete.frame.width/2)
        
        btnSave.setRounded(rounded: 8)
        
        inputQty.keyboardType = .numberPad
        
        btnDelete.addTarget(self, action: #selector(handleDeleteQty), for: .touchUpInside)
        btnAdd.addTarget(self, action: #selector(handleAddQty), for: .touchUpInside)
        btnSave.addTarget(self, action: #selector(handleSaveProduct), for: .touchUpInside)
        
        setupValue()
    }
    
    func setupValue() {
        
        guard let item = viewModel.output.getProducItems() else { return }
        
        titleName.text = item.productName
        descText.text = item.productDesc
        
        
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
        
        guard let urlImage = URL(string: "\(DomainNameConfig.TMSImagePath.urlString)\(item.productImg ?? "")") else { return }
        posterImageView.kf.setImageDefault(with: urlImage)
        
    }
}

extension ProductDetailBottomSheetViewController {
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

