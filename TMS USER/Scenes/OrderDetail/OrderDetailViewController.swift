//
//  OrderDetailViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import UIKit

public enum OrderDetailType {
    case orderDetail
    case orderHistoryDetail
}

class OrderDetailViewController: UIViewController {
    
    @IBOutlet var orderIdText: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var priceAllText: UILabel!
    @IBOutlet var priceDiscountText: UILabel!
    @IBOutlet var priceOverAllText: UILabel!
    
    
    @IBOutlet var bgReOrder: UIView!
    @IBOutlet var btnReOrder: UIButton!
    
    @IBOutlet var bgReviewOrder: UIView!
    @IBOutlet var btnReviewOrder: UIButton!
    
    
    @IBOutlet var bgCancelOrder: UIView!
    @IBOutlet var btnCancelOrder: UIButton!
    
    lazy var viewModel: OrderDetailProtocol = {
        let vm = OrderDetailViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgReOrder.isHidden = true
        bgReviewOrder.isHidden = true
        bgCancelOrder.isHidden = true
        registerCell()
    }
    
    func configure(_ interface: OrderDetailProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.input.getOrderDetail()
        NavigationManager.instance.setupWithNavigationController(self.navigationController)
    }
}


// MARK: - Binding
extension OrderDetailViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetOrderDetailSuccess = didGetOrderDetailSuccess()
        
    }
    
    func didGetOrderDetailSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.setupUI()
            self.tableView.reloadData()
            self.setupValueOrder()
        }
    }
}


extension OrderDetailViewController {
    
    func setupUI(){
        bgReOrder.isHidden = true
        bgReviewOrder.isHidden = true
        bgCancelOrder.isHidden = true
        if viewModel.output.getOrderDetailType() == .orderDetail {
            bgReOrder.isHidden = false
            self.setupButtonOrder(button: self.btnReOrder, title: "สั่งซื้ออีกครั้ง", action: #selector(self.didTapReOrder))
        } else if viewModel.output.getOrderDetailType() == .orderHistoryDetail {
            
            switch viewModel.output.getOrderDetailButtonType() {
            case .reOrder:
                bgReOrder.isHidden = false
                self.setupButtonOrder(button: self.btnReOrder, title: "สั่งซื้ออีกครั้ง", action: #selector(self.didTapReOrder))
                    break
            case .reviewOrder:
                bgReviewOrder.isHidden = false
                self.setupButtonOrder(button: self.btnReviewOrder, title: "ให้คะแนน", action: #selector(self.didTapReviewOrder))
                    break
            case .cancelOrder:
                bgCancelOrder.isHidden = false
                self.setupButtonOrder(button: self.btnCancelOrder, title: "ยกเลิกคำสั่งซื้อ", action: #selector(self.didTapCancelOrder))
                    break
            default:
                break
            }
        }
    }
    
    private func setupButtonOrder(button: UIButton, title: String, action: Selector) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            button.setRounded(rounded: 8)
            button.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                         locations: [0.5, 1.0],
                                         direction: .leftToRight,
                                         cornerRadius: 8)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.textColor = .white
            button.addTarget(self, action: action, for: .touchUpInside)
        }
    }
    
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        tableView.separatorStyle = .none
        //Header
        tableView.register(HeaderLabelTableViewCell.self, forHeaderFooterViewReuseIdentifier: HeaderLabelTableViewCell.identifier)
        //Cell
        tableView.registerCell(identifier: EmployeeTableViewCell.identifier)
        tableView.registerCell(identifier: ProductListTableViewCell.identifier)
    }
    
    func setupValueOrder() {
        orderIdText.text = "Order ID : \(viewModel.output.getOrderNo())"
        priceAllText.text = "\(viewModel.output.getSumPrice())"
        priceDiscountText.text = "\(viewModel.output.getDiscountPrice())"
        priceOverAllText.text = "\(viewModel.output.getOverAllPrice())"
    }
    
    @objc func didTapReOrder() {
        viewModel.input.didCreateOrder()
    }
    
    @objc func didTapReviewOrder() {
        guard let orderId = viewModel.output.getOrderId() else { return }
        NavigationManager.instance.pushVC(to: .customerReview(orderId: orderId))
    }
    
    @objc func didTapCancelOrder() {
        viewModel.input.didCancelOrder()
    }
}

extension OrderDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.output.getHeightSectionView(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}

extension OrderDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(tableView, section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.getNumberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.output.getHeaderViewCell(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

