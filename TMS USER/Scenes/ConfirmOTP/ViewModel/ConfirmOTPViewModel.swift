//
//  ConfirmOTPViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 14/5/2565 BE.
//

import Foundation
import UIKit
import Combine

public protocol ConfirmOTPViewModelDelegate {
    func didConfirmOTPSuccess()
}

protocol ConfirmOTPProtocolInput {
    func setup(_ delegate: ConfirmOTPViewModelDelegate, _ phone: String)
    func requestOTP()
    func verifyOTP(otpCode: String)
}

protocol ConfirmOTPProtocolOutput: class {
    var didRequestOTPSuccess: (() -> Void)? { get set }
    var didVerifyOTPSuccess: (() -> Void)? { get set }
    var didEnableResendOTPSuccess: ((Bool) -> Void)? { get set }
    
    func getRequestOTPResponse() -> OTPResponse?
}

protocol ConfirmOTPProtocol: ConfirmOTPProtocolInput, ConfirmOTPProtocolOutput {
    var input: ConfirmOTPProtocolInput { get }
    var output: ConfirmOTPProtocolOutput { get }
}

class ConfirmOTPViewModel: ConfirmOTPProtocol, ConfirmOTPProtocolOutput {
    var input: ConfirmOTPProtocolInput { return self }
    var output: ConfirmOTPProtocolOutput { return self }
    
    // MARK: - Properties
    private var postAuthenticateUseCase: PostAuthenticateUseCase
    private var authCustomerRepository: AuthCustomerRepository
    private var thaibulkSMSRepository: ThaibulkSMSRepository
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    
    private var vc: ConfirmOTPViewController
    
    public var delegate: ConfirmOTPViewModelDelegate?
    private var phone: String? = nil
    
    //requestOTP
    private var requestOTPResponse: OTPResponse? = nil
    
    init(
        vc: ConfirmOTPViewController,
        postAuthenticateUseCase: PostAuthenticateUseCase = PostAuthenticateUseCaseImpl(),
        authCustomerRepository: AuthCustomerRepository = AuthCustomerRepositoryImpl(),
        thaibulkSMSRepository: ThaibulkSMSRepository = ThaibulkSMSRepositoryImpl()
    ) {
        self.vc = vc
        self.postAuthenticateUseCase = postAuthenticateUseCase
        self.authCustomerRepository = authCustomerRepository
        self.thaibulkSMSRepository = thaibulkSMSRepository
    }
    
    // MARK - Data-binding OutPut
    var didRequestOTPSuccess: (() -> Void)?
    var didVerifyOTPSuccess: (() -> Void)?
    var didEnableResendOTPSuccess: ((Bool) -> Void)?
    
    func setup(_ delegate: ConfirmOTPViewModelDelegate, _ phone: String) {
        self.delegate = delegate
        self.phone = phone
    }
    
    func requestOTP() {
        guard let phone = self.phone, phone.count == 10 else { return }
        self.vc.startLoding()
        var request = OTPRequest()
        request.msisdn = phone
        self.thaibulkSMSRepository.requestOTP(request: request).sink { completion in
            debugPrint("thaibulkSMS requestOTP \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if resp.code == 400, let msg = resp.errors?.first?.message {
                ToastManager.shared.toastCallAPI(title: msg)
            } else {
                self.requestOTPResponse = resp
                self.didRequestOTPSuccess?()
            }
            self.didEnableResendOTPSuccess?(false)
        }.store(in: &self.anyCancellable)
    }
    
    func verifyOTP(otpCode: String) {
        guard let token = self.requestOTPResponse?.token else { return }
        self.vc.startLoding()
        var request = OTPRequest()
        request.token = token
        request.pin = otpCode
        self.thaibulkSMSRepository.verifyOTP(request: request).sink { completion in
            debugPrint("thaibulkSMS verifyOTP \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            self.didEnableResendOTPSuccess?(false)
            if resp.code == 400, let msg = resp.errors?.first?.message {
                if msg.contains("Token is expire.") {
                    self.didEnableResendOTPSuccess?(true)
                } else {
                    self.didEnableResendOTPSuccess?(false)
                }
                ToastManager.shared.toastCallAPI(title: msg)
            } else {
                if resp.status == "success", let msg = resp.message {
                    ToastManager.shared.toastCallAPI(title: msg)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.vc.dismiss(animated: true, completion: {
                            self.delegate?.didConfirmOTPSuccess()
                        })
                    }
                }
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getRequestOTPResponse() -> OTPResponse? {
        return self.requestOTPResponse
    }

}
