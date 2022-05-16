//
//  ConfirmOTPViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 14/5/2565 BE.
//

import UIKit

class ConfirmOTPViewController: UIViewController {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var inputOTP: UITextField!
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var btnResendOTP: UIButton!
    
    @IBOutlet var titleRefCode: UILabel!
    
    // ViewModel
    lazy var viewModel: ConfirmOTPProtocol = {
        let vm = ConfirmOTPViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() 
        registerKeyboardObserver()
        viewModel.input.requestOTP()
    }
    
    func configure(_ interface: ConfirmOTPProtocol) {
        self.viewModel = interface
    }
    
    deinit {
       removeObserver()
    }
}

// MARK: - Binding
extension ConfirmOTPViewController {
    
    func bindToViewModel() {
        viewModel.output.didRequestOTPSuccess = didRequestOTPSuccess()
        viewModel.output.didEnableResendOTPSuccess = didEnableResendOTPSuccess()
    }
    
    func didRequestOTPSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            if let resp = self.viewModel.output.getRequestOTPResponse() {
                self.titleRefCode.text = "Ref: \(resp.refno ?? "-")"
            }
        }
    }
    
    func didEnableResendOTPSuccess() -> ((Bool) -> Void) {
        return { [weak self] status in
            guard let self = self else { return }
            self.inputOTP.text = ""
            self.btnResendOTP.isHidden = !status
        }
    }

}

extension ConfirmOTPViewController {
    func setupUI() {
        topView.roundCorners(.bottomLeft, radius: 20)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.bottomView.roundedTop(radius: 20)
        }
        
        btnResendOTP.isHidden = true
        titleRefCode.font = .PrimaryBold(size: 16)
        
        inputOTP.setRounded(rounded: 8)
        inputOTP.setBorder(width: 1.0, color: UIColor.Primary)
        
        btnConfirm.setRounded(rounded: 8)
        btnConfirm.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        
        btnResendOTP.setRounded(rounded: 8)
        btnResendOTP.addTarget(self, action: #selector(handleResendOTP), for: .touchUpInside)
        
        titleRefCode.text = "Ref: -"
        
        inputOTP.text = ""
    }
}

extension ConfirmOTPViewController {
    @objc func handleConfirm() {
        guard let otpCode = self.inputOTP.text, otpCode != "" else { return }
        viewModel.input.verifyOTP(otpCode: otpCode)
    }
    
    @objc func handleResendOTP() {
        viewModel.input.requestOTP()
    }
}

extension ConfirmOTPViewController : KeyboardListener {
    func keyboardDidUpdate(keyboardHeight: CGFloat) {
        bottomConstraint.constant = keyboardHeight
    }
}
