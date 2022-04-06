//
//  CollectibleExchangeViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 3/4/2565 BE.
//

import UIKit

class CollectibleExchangeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textEmptyData: TextEmptyData!
    
    lazy var viewModel: CollectibleExchangeProtocol = {
        let vm = CollectibleExchangeViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func configure(_ interface: CollectibleExchangeProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.input.getCollectibleForUser()
        NavigationManager.instance.setupWithNavigationController(self.navigationController)
        self.textEmptyData.isHidden = true
        self.tableView.isHidden = false
    }
    
}

extension CollectibleExchangeViewController {
    func setupUI() {
        registerCell()
    }
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tableView.separatorStyle = .none
        tableView.registerCell(identifier: CollectibleTableViewCell.identifier)
    }
    
    func checkEmptyData() {
        if self.viewModel.output.getNumberOfRowsInSection(UITableView(), section: 1) == 0 {
            self.textEmptyData.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.textEmptyData.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

// MARK: - Binding
extension CollectibleExchangeViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetCollectibleExchangeSuccess = didGetCollectibleExchangeSuccess()
    }
    
    func didGetCollectibleExchangeSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension CollectibleExchangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension CollectibleExchangeViewController: UITableViewDataSource {
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
