//
//  OrderViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    lazy var viewModel: OrderProtocol = {
        let vm = OrderViewModel(orderViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
    }
    
    func configure(_ interface: OrderProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.input.getOrder()
    }
}


// MARK: - Binding
extension OrderViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetOrderSuccess = didGetOrderSuccess()
    }
    
    func didGetOrderSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}


extension OrderViewController {
    func setupUI(){
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
    }
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        tableView.separatorStyle = .none
        tableView.registerCell(identifier: OrderTableViewCell.identifier)
    }
}

extension OrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(tableView, section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.getNumberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
}
