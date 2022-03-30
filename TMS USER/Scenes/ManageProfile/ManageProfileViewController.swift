//
//  ManageProfileViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 31/3/2565 BE.
//

import UIKit

class ManageProfileViewController: UIViewController {
    
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var nameText: UILabel!
    @IBOutlet var nameShopText: ValueManageProfile!
    @IBOutlet var typeUserText: ValueManageProfile!
    @IBOutlet var telText: ValueManageProfile!
    @IBOutlet var addressText: ValueManageProfile!
    
    lazy var viewModel: ManageProfileProtocol = {
        let vm = ManageProfileViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.input.getProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func configure(_ interface: ManageProfileProtocol) {
        self.viewModel = interface
    }
    
    func setupUI() {
        avatarImageView.setRounded(rounded: avatarImageView.frame.width/2)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.setBorder(width: 1, color: .white)

        let editUser = UIBarButtonItem(image: UIImage.init(systemName: "pencil"), style: .plain, target: self, action: #selector(handleEditUser))

        navigationItem.rightBarButtonItem = editUser
    }
    
    func setupValueUser() {
        guard let user = viewModel.output.getMyUser() else { return }
        nameText.text = user.displayName ?? "-"
        telText.text = user.tel ?? "-"
        typeUserText.text = user.typeUser?.typeName ?? "-"
        addressText.text = user.address ?? "-"
        nameShopText.text = user.fname ?? "-"
        setImage(url: user.avatar)
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(url ?? "")") else { return }
        avatarImageView.kf.setImageDefault(with: urlImage)
    }
    
    @objc func handleEditUser() {
        NavigationManager.instance.pushVC(to: .register)
    }
    
}

// MARK: - Binding
extension ManageProfileViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetProfileSuccess = didGetProfileSuccess()
    }
    
    func didGetProfileSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupValueUser()
        }
    }
}
