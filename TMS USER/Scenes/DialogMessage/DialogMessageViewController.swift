//
//  DialogMessageViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 6/4/2565 BE.
//

import UIKit

public enum DialogMessageType {
    case success
    case confirm
    case error
}

protocol DialogViewDelegate {
    func didClose()
    func didAccept()
    func didCancal()
}

public protocol DialogMessageViewControllerDelegate {
    func didAccept(_ type: DialogMessageType, vc: UIViewController)
}

class DialogMessageViewController: UIViewController {
    
    public var dialogMessageType: DialogMessageType = .confirm

    @IBOutlet var acceptDialogView: AcceptDialogView!
    @IBOutlet var errorDialogView: ErrorDialogView!
    @IBOutlet var successDialogView: SuccessDialogView!
    
    public var delegate: DialogMessageViewControllerDelegate?
    
    public var msgAccept: AcceptDialogMsg?
    public var msgError: ErrorDialogMsg?
    public var msgSuccess: SuccessDialogMsg?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptDialogView.isHidden = true
        errorDialogView.isHidden = true
        successDialogView.isHidden = true

        switch dialogMessageType {
        case .success:
            setupSuccessDialogView()
        case .confirm:
            setupAcceptDialogView()
        case .error:
            setupErrorDialogView()
        }
    }
    
    func setupAcceptDialogView() {
        self.acceptDialogView.isHidden = false
        self.acceptDialogView.delegate = self
        self.acceptDialogView.setMessage(msg: msgAccept)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.acceptDialogView.setGradientColor()
        }
    }
    
    func setupErrorDialogView() {
        self.errorDialogView.isHidden = false
        self.errorDialogView.delegate = self
        self.errorDialogView.setMessage(msg: msgError)
    }
    
    func setupSuccessDialogView() {
        self.successDialogView.isHidden = false
        self.successDialogView.delegate = self
        self.successDialogView.setMessage(msg: msgSuccess)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.successDialogView.logoImage.roundedTop(radius: 8)
        }
    }
}

extension DialogMessageViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        segue.destination.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension DialogMessageViewController: DialogViewDelegate {
    func didAccept() {
        self.delegate?.didAccept(.confirm, vc: self)
    }
    
    func didCancal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
