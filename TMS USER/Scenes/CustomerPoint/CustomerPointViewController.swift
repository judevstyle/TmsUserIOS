//
//  CustomerPointViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 2/4/2565 BE.
//

import UIKit

class CustomerPointViewController: UIViewController {
    
    
    @IBOutlet var pointText: TextValuePoint!
    @IBOutlet var btnExchangeCoin: ButtonExchangePoint!
    @IBOutlet var tableView: UITableView!
    
    
    lazy var viewModel: CustomerPointProtocol = {
        let vm = CustomerPointViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.input.getCustomerPoint()
        viewModel.input.getMyRewardPoint()
        setupUI()
    }
    
    func setupUI() {
    }
    
    func configure(_ interface: CustomerPointProtocol) {
        self.viewModel = interface
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
//        tableView.separatorStyle = .none
        tableView.registerCell(identifier: MyRewardPointTableViewCell.identifier)
    }
    @IBAction func handleButtonCoin(_ sender: Any) {
        NavigationManager.instance.pushVC(to: .collectibleExchange)
    }
    
}

// MARK: - Binding
extension CustomerPointViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetCustomerPointSuccess = didGetCustomerPointSuccess()
        viewModel.output.didGetMyRewardPointSuccess = didGetMyRewardPointSuccess()
    }
    
    func didGetCustomerPointSuccess() -> ((Int) -> Void) {
        return { total in
            self.pointText.text = "\(total)"
        }
    }
    
    func didGetMyRewardPointSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

// MARK: - Event
extension CustomerPointViewController {

}

// MARK: - TableView
extension CustomerPointViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension CustomerPointViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfProfile(tableView, section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.getNumberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
}
