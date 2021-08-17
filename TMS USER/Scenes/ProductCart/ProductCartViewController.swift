//
//  ProductCartViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import UIKit

class ProductCartViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sumPrice: UILabel!
    @IBOutlet var discountPrice: UILabel!
    @IBOutlet var sumOverAll: UILabel!
    
    public var dismiss: (() -> Void?)? = nil
    
    @IBOutlet var btnConfirmOrder: UIButton!
    @IBOutlet var productLabelEmpty: UILabel!
    
    lazy var viewModel: ProductCartProtocol = {
        let vm = ProductCartViewModel(productCartViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
        viewModel.input.getProductCart()
    }
    
    func configure(_ interface: ProductCartProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        viewModel.input.fetchOrderCart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss?()
    }
}

// MARK: - Binding
extension ProductCartViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetProductCartSuccess = didGetProductCartSuccess()
    }
    
    func didGetProductCartSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            weakSelf.setValueSumAll()
        }
    }
}

extension ProductCartViewController {
    func setupUI(){
        setupDismissItem()
        
        btnConfirmOrder.applyGradient(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                     locations: [0.5, 1.0],
                                     direction: .leftToRight,
                                     cornerRadius: 0)
        
        btnConfirmOrder.addTarget(self, action: #selector(didConfirmOrder), for: .touchUpInside)
        productLabelEmpty.isHidden = true
        tableView.isHidden = false
    }
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.registerCell(identifier: ProductCartTableViewCell.identifier)
    }
    
    private func setupDismissItem(){
        
        let dismissItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(dissmissPage))
        dismissItem.tintColor = .white
        self.navigationItem.leftBarButtonItem = dismissItem
    }
    
    @objc private func dissmissPage(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setValueSumAll() {
        sumPrice.text = "\(viewModel.output.getSumPrice())"
        discountPrice.text = "\(viewModel.output.getDiscountPrice())"
        sumOverAll.text = "\(viewModel.output.getOverAllPrice())"
    }
    
    @objc private func didConfirmOrder(){
        viewModel.input.didConfirmOrderCart()
    }
}

extension ProductCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension ProductCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cont = viewModel.output.getNumberOfProductCart(tableView, section: section)
        
        if cont <= 0 {
            productLabelEmpty.isHidden = false
            tableView.isHidden = true
        } else {
            productLabelEmpty.isHidden = true
            tableView.isHidden = false
        }
        
        return cont
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.getNumberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
}
