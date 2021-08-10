//
//  OrderDetailViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet var orderIdText: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var priceAllText: UILabel!
    @IBOutlet var priceDiscountText: UILabel!
    @IBOutlet var priceOverAllText: UILabel!
    @IBOutlet var btnCreateOrder: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension OrderDetailViewController {
    func setupUI() {
        btnCreateOrder.setRounded(rounded: 8)
        btnCreateOrder.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                     locations: [0.5, 1.0],
                                     direction: .leftToRight,
                                     cornerRadius: 5)
    }
}
