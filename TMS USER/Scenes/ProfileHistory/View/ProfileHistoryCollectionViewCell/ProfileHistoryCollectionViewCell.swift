//
//  ProfileHistoryCollectionViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import UIKit

class ProfileHistoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "ProfileHistoryCollectionViewCell"
    
    public var typeTopNav: TopNavProfileHistoryType?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textEmptyData: TextEmptyData!
    
    // ViewModel
    lazy var viewModel: ProfileHistoryCollectionProtocol = {
        let vm = ProfileHistoryCollectionViewModel()
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupTableView()
//        self.textEmptyData.isHidden = false
//        self.tableView.isHidden = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.registerCell(identifier: OrderProfileHistoryTableViewCell.identifier)
        tableView.registerCell(identifier: OrderSendingTableViewCell.identifier)
    }
    
    func setupUI() {

    }

    func configure(_ interface: ProfileHistoryCollectionProtocol) {
        self.viewModel = interface
    }

}

// MARK: - Binding
extension ProfileHistoryCollectionViewCell {

    func bindToViewModel() {
        viewModel.output.didGetCellSuccess = didGetCellSuccess()
    }

    func didGetCellSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            if let countItems = self.viewModel.output.getItemOrder()?.count, countItems > 0 {
                self.tableView.reloadData()
                self.textEmptyData.isHidden = true
                self.tableView.isHidden = false
            } else {
                self.textEmptyData.isHidden = false
                self.tableView.isHidden = true
            }
        }
    }
}

extension ProfileHistoryCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(tableView, section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
