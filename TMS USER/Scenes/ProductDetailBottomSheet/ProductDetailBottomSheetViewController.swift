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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}


extension ProductDetailBottomSheetViewController {
    func setupUI() {
        btnAdd.setRounded(rounded: btnAdd.frame.width/2)
        btnDelete.setRounded(rounded: btnDelete.frame.width/2)
        
        btnSave.setRounded(rounded: 8)
    }
}
