//
//  IntroViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var bottomView: UIView!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnLogin: UIButton!
    
    // ViewModel
    lazy var viewModel: IntroProtocol = {
        let vm = IntroViewModel(introViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.input.checkAuth()
        NavigationManager.instance.setupWithNavigationController(self)
    }
    
    func configure(_ interface: IntroProtocol) {
        self.viewModel = interface
    }
}

// MARK: - Binding
extension IntroViewController {
    
    func bindToViewModel() {
        viewModel.output.didAuthSuccess = didAuthSuccess()
    }
    
    func didAuthSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            NavigationManager.instance.setRootViewController(rootView: .mainApp, withNav: false, isTranslucent: true)
        }
    }
}

extension IntroViewController {
    func setupUI() {
        
        NavigationManager.instance.setupWithNavigationController(self.navigationController)
        
        topView.roundCorners(.topRight, radius: 20)
        topView.roundCorners(.bottomRight, radius: 20)
        
        bottomView.roundedTop(radius: 20)
        
        
        btnLogin.setRounded(rounded: 8)
        btnLogin.setBorder(width: 1.0, color: UIColor.Primary)
        btnLogin.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        btnRegister.setRounded(rounded: 8)
        btnRegister.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
}

extension IntroViewController {
    @objc func handleLogin() {
        NavigationManager.instance.pushVC(to: .login, presentation: .ModalNoNav(completion: nil))
    }
    
    @objc func handleRegister() {
        NavigationManager.instance.pushVC(to: .register, presentation: .Push)
    }
}
