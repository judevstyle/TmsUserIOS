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
    
    lazy var viewModel: OrderDetailProtocol = {
        let vm = OrderDetailViewModel(orderDetailViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
    }
    
    func configure(_ interface: OrderDetailProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.input.getOrderDetail()
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
    }
}


// MARK: - Binding
extension OrderDetailViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetOrderDetailSuccess = didGetOrderDetailSuccess()
    }
    
    func didGetOrderDetailSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            weakSelf.setupValueOrder()
        }
    }
}


extension OrderDetailViewController {
    func setupUI(){
        btnCreateOrder.setRounded(rounded: 8)
        btnCreateOrder.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                     locations: [0.5, 1.0],
                                     direction: .leftToRight,
                                     cornerRadius: 5)
        btnCreateOrder.addTarget(self, action: #selector(didTapCreateOrder), for: .touchUpInside)
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
    }
    
    @objc func didTapCreateOrder() {
        viewModel.input.didCreateOrder()
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

