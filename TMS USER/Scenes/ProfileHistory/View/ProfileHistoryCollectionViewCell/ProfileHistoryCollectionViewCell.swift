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
        self.textEmptyData.isHidden = false
        self.tableView.isHidden = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
//        tableView.registerCell(identifier: ContentTableViewCell.identifier)
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
//        viewModel.output.didGetInformationSuccess = didGetInformationSuccess()
    }

    func didGetInformationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension ProfileHistoryCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(tableView, section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}
