//
//  HistoryViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    lazy var viewModel: HistoryProtocol = {
        let vm = HistoryViewModel(historyViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
    }
    
    func configure(_ interface: HistoryProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.input.getHistory()
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
    }
}


// MARK: - Binding
extension HistoryViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetHistorySuccess = didGetHistorySuccess()
        viewModel.output.didNavigateOrderDetail = didNavigateOrderDetail()
    }
    
    func didGetHistorySuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
    
    func didNavigateOrderDetail() -> ((Int?) -> Void) {
        return { orderId in
            NavigationManager.instance.pushVC(to: .orderDetail(orderId: orderId))
        }
    }
}


extension HistoryViewController {
    func setupUI(){
    }
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        tableView.separatorStyle = .none
        tableView.registerCell(identifier: HistoryTableViewCell.identifier)
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension HistoryViewController: UITableViewDataSource {
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
