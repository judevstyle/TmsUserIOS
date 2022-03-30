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
    
    @IBOutlet var pointText: UILabel!
    
    lazy var viewModel: ProfileProtocol = {
        let vm = ProfileViewModel(vc: self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationManager.instance.setupWithNavigationController(self)
        
        viewModel.input.getProfile()
        viewModel.input.getCustomerPoint()
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
        viewModel.output.didGetCustomerPointSuccess = didGetCustomerPointSuccess()
    }
    
    func didGetProfileSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            weakSelf.setupValueUser()
        }
    }
    
    func didLogoutSuccess() -> (() -> Void) {
        return { [weak self] in
            NavigationManager.instance.setRootViewController(rootView: .intro, isTranslucent: true)
        }
    }
    
    func didGetCustomerPointSuccess() -> ((Int) -> Void) {
        return { total in
            self.pointText.text = "\(total) คะแนน"
        }
    }
}


extension ProfileViewController {
    func setupUI(){
        avatarImageView.setRounded(rounded: avatarImageView.frame.width/2)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.setBorder(width: 1, color: .white)
    }
    
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.registerCell(identifier: ProfileTableViewCell.identifier)
    }
    
    func setupValueUser() {
        guard let user = viewModel.output.getMyUser() else { return }
        nameText.text = user.displayName ?? "-"
        telText.text = "เบอร์โทร \(user.tel ?? "-")"
        typeText.text = "ประเภทสมาชิก \( user.typeUser?.typeName ?? "-")"
        setImage(url: user.avatar)
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(url ?? "")") else { return }
        avatarImageView.kf.setImageDefault(with: urlImage)
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

