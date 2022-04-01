//
//  LoginViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var inputPhone: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    // ViewModel
    lazy var viewModel: LoginProtocol = {
        let vm = LoginViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardObserver()

    }
    
    func configure(_ interface: LoginProtocol) {
        self.viewModel = interface
    }
    
    deinit {
       removeObserver()
    }
}

// MARK: - Binding
extension LoginViewController {
    
    func bindToViewModel() {
        viewModel.output.didLoginSuccess = didLoginSuccess()
        viewModel.output.didLoginError = didLoginError()
    }
    
    func didLoginSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            NavigationManager.instance.setRootViewController(rootView: .mainApp, withNav: false, isTranslucent: true)
        }
    }
    
    func didLoginError() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
        }
    }
}

extension LoginViewController {
    func setupUI() {
        topView.roundCorners(.bottomLeft, radius: 20)
        
        bottomView.roundedTop(radius: 20)
        
        btnLogin.setRounded(rounded: 8)
        inputPhone.setRounded(rounded: 8)
        inputPhone.setBorder(width: 1.0, color: UIColor.Primary)
        
        btnLogin.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        inputPhone.text = "0910000003"
    }
}

extension LoginViewController {
    @objc func handleLogin() {
        guard let tel = self.inputPhone.text, tel != "" else { return }
        var request: PostAuthenticateRequest = PostAuthenticateRequest()
        request.tel = tel
        viewModel.input.authLogin(request: request)
    }
    
    @objc func handleRegister() {
        guard let tel = self.inputPhone.text, tel != "" else { return }
        var request: PostAuthenticateRequest = PostAuthenticateRequest()
        request.tel = tel
        viewModel.input.authLogin(request: request)
    }
}

extension LoginViewController : KeyboardListener {
    func keyboardDidUpdate(keyboardHeight: CGFloat) {
        bottomConstraint.constant = keyboardHeight
    }
}
