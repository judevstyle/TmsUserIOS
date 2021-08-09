//
//  ProfileViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var statusBarHeight: NSLayoutConstraint!
    
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameText: UILabel!
    @IBOutlet var telText: UILabel!
    @IBOutlet var typeText: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    lazy var viewModel: ProfileProtocol = {
        let vm = ProfileViewModel(profileViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let height = getStatusBarHeight()
        statusBarHeight.constant = height
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        setupUI()
        registerCell()
    }
    
    func configure(_ interface: ProfileProtocol) {
        self.viewModel = interface
    }
    
    
    func getStatusBarHeight() -> CGFloat {
       var statusBarHeight: CGFloat = 0
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
       return statusBarHeight
    }
}


// MARK: - Binding
extension ProfileViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetProfileSuccess = didGetProfileSuccess()
        viewModel.output.didLogoutSuccess = didLogoutSuccess()
    }
    
    func didGetProfileSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
    
    func didLogoutSuccess() -> (() -> Void) {
        return { [weak self] in
            NavigationManager.instance.setRootViewController(rootView: .intro, isTranslucent: true)
        }
    }
}


extension ProfileViewController {
    func setupUI(){
        
    }
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.registerCell(identifier: ProfileTableViewCell.identifier)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension ProfileViewController: UITableViewDataSource {
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

